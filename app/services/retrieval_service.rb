# frozen_string_literal: true

class RetrievalService
  def initialize(embedding_service: EmbeddingService.new)
    @embedder = embedding_service
  end

  def search_by_query(query_text, top: 5, neighborhoods: nil, price_level: nil)
    restaurants = RestaurantQuery.new(
      query_text: query_text,
      neighborhoods: neighborhoods,
      price_level: price_level,
      top: top
    ).closest_restaurants

    restaurants.map do |restaurant|
      { restaurant: restaurant, similarity: restaurant.similarity }
    end
  end
end
