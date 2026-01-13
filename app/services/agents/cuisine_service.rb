# frozen_string_literal: true

module Agents
  class CuisineService
    SYSTEM = <<~SYS.freeze
      You are a Cuisine Extraction assistant.#{' '}
      Convert the user's natural language text into canonical cuisine tags, dietary filters, and price level.
      Return JSON only with keys:
        - cuisines (array of short strings)
        - dietary (array of short strings, like "vegetarian", "vegan", "gluten-free")
        - price ("cheap"|"moderate"|"expensive"|"any")
    SYS

    def initialize(client: OpenAIClient, model: ENV.fetch('OPENAI_CHAT_MODEL', 'gpt-4o-mini'))
      @client = client
      @model = model
    end

    def extract(user_text)
      messages = [
        { role: 'system', content: SYSTEM },
        { role: 'user', content: user_text }
      ]

      resp = @client.chat.completions.create!(messages: messages, model: @model)
      content = resp.choices.first.message.content
      begin
        JSON.parse(content)
      rescue StandardError
        parse_freeform(content)
      end
    end

    private

    def parse_freeform(text)
      cuisines = []
      cuisines << 'vegetarian' if /vegetarian|veggie/i.match?(text)
      cuisines << 'italian' if /italian/i.match?(text)
      cuisines << 'mexican' if /mexican|mex/i.match?(text)
      dietary = []
      dietary << 'vegetarian' if /vegetarian/i.match?(text)
      price = case text
              when /cheap|inexpensive|budget|economical/i
                'cheap'
              when /moderate|moderately|mid[- ]range/i
                'moderate'
              when /expensive|high[- ]end|deluxe/i
                'expensive'
              else
                'any'
              end

      { 'cuisines' => cuisines, 'dietary' => dietary, 'price' => price }
    end
  end
end
