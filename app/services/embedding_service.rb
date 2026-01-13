# frozen_string_literal: true

class EmbeddingService
  EMBEDDING_MODEL = ENV.fetch('OPENAI_EMBEDDING_MODEL', 'text-embedding-3-small')

  def initialize(client: OpenAIClient)
    @embeddings = OpenAI::Resources::Embeddings.new(client: client)
  end

  def embed(text)
    return if text.blank?

    resp = @embeddings.create!(input: text, model: EMBEDDING_MODEL)
    data = resp.data[0].embedding
    raise "Embedding error: #{resp}" unless data

    data
  end
end
