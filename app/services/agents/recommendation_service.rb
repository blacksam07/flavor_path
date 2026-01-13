# frozen_string_literal: true

module Agents
  class RecommendationService
    SYSTEM = <<~SYS
      You are a Recommendation Agent. Given a user query, agent-extracted constraints, and a set of retrieved restaurant documents,
      produce a JSON array of up to 3 restaurant recommendations. Each item must contain:
        - name
        - neighborhood
        - price_level (1|2|3)
        - reasons (array of 1-3 concise strings linked explicitly to retrieved evidence)
        - evidence (array of short snippets taken from retrieved docs)
        - match_score (0.0 - 1.0)
      Use ONLY the provided retrieved documents for facts. If none match, say "no matches".
    SYS

    def initialize(openai_client: OpenAIClient, model: ENV.fetch('OPENAI_CHAT_MODEL', 'gpt-4o-mini'))
      @client = openai_client
      @model = model
      @retrieval = RetrievalService.new
    end

    def recommend(user_query)
      cuisine_out = Agents::CuisineService.new.extract(user_query)
      location_out = Agents::LocationService.new.neighborhoods(user_query)

      retrieval_query = [
        user_query,
        "cuisines: #{(cuisine_out['cuisines'] || []).join(', ')}",
        "dietary: #{(cuisine_out['dietary'] || []).join(', ')}"
      ].join(' | ')

      price_level = map_price_string_to_int(cuisine_out['price'])
      candidates = @retrieval.search_by_query(retrieval_query, top: 8, neighborhoods: location_out,
                                                               price_level: price_level)

      docs_text = candidates.map.with_index(1) { |h, i|
        r = h[:restaurant]
        sim = h[:similarity]
        <<~DOC
          Doc #{i}:
            name: #{r.name}
            neighborhood: #{r.neighborhood}
            price_level: #{r.price_level}
            cuisine_tags: #{r.cuisine_tags.join(', ')}
            description: #{r.description}
            top_reviews: #{(r.reviews || []).map { |rev| rev['text'] }.first(2).join(' | ')}
            similarity: #{sim}
        DOC
      }.join("\n\n")

      messages = [
        { role: 'system', content: SYSTEM },
        { role: 'user', content: <<~USER }
          User query: #{user_query}
          Cuisine agent output: #{cuisine_out.to_json}
          Location agent output: #{location_out.to_json}

          Retrieved Documents:
          #{docs_text}

          Task:
          - Return a JSON array format that permit to be parsed as a ruby array, with max 3 items. Use only information from Retrieved Documents.
        USER
      ]

      resp = @client.chat.completions.create!(messages: messages, model: @model, max_tokens: 800)
      resp.choices.first.message.content
    rescue StandardError
      { error: 'could not generate recommendations' }
    end

    private

    def map_price_string_to_int(str)
      case str&.downcase
      when 'cheap' then 1
      when 'moderate' then 2
      when 'expensive' then 3
      end
    end
  end
end
