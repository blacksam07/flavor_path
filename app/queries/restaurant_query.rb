# frozen_string_literal: true

class RestaurantQuery
  MAX_RESULTS = 5

  attr_reader :query_text, :neighborhoods, :price_level

  def initialize(query_text: nil, neighborhoods: nil, price_level: nil, top: MAX_RESULTS)
    @relation = Restaurant.extending(Scope)
    @query_text = query_text
    @neighborhoods = neighborhoods
    @price_level = price_level
    @top = top
  end

  def closest_restaurants
    @relation.select_with_similarity(vector_literal)
             .by_neighborhoods(neighborhoods)
             .by_price_level(price_level)
             .embedding_present
             .order_by_embedding(vector_literal)
             .limit_results
  end

  private

  def vector_literal
    @vector_literal ||= "ARRAY[#{EmbeddingService.new.embed(query_text).join(',')}]::vector"
  end

  module Scope
    def select_with_similarity(vector_literal)
      select("restaurants.*, (1 - (embedding <#> #{vector_literal})) AS similarity")
    end

    def embedding_present
      where.not(embedding: nil)
    end

    def by_neighborhoods(neighborhoods)
      return self if neighborhoods.blank?

      where(neighborhood: neighborhoods)
    end

    def by_price_level(price_level)
      return self if price_level.blank?

      where(price_level: price_level)
    end

    def order_by_embedding(_vector_literal)
      order(similarity: :desc)
    end

    def limit_results
      limit(MAX_RESULTS)
    end
  end
end
