# frozen_string_literal: true

class GenerateRestaurantEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform(restaurant_id = nil)
    restaurants(restaurant_id).find_each do |restaurant|
      text = restaurant.content_for_embedding
      next if text.blank?

      vector = embedder.embed(text)
      restaurant.update!(embedding: vector)
      Rails.logger.info "Embedded restaurant #{restaurant.id}"
    rescue StandardError => e
      Rails.logger.error "Embedding failed for #{restaurant.id}: #{e.message}"
    end
  end

  private

  def restaurants(restaurant_id)
    return Restaurant.where(id: restaurant_id) if restaurant_id

    Restaurant.all
  end

  def embedder
    @embedder ||= EmbeddingService.new
  end
end
