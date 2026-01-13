# frozen_string_literal: true

module API
  module V1
    class RecommendationsController < ApplicationController
      protect_from_forgery with: :null_session
      skip_after_action :verify_authorized, :verify_policy_scoped

      def create
        @recommendations = recommendation_service.recommend(params[:query])
        render json: clean_json(@recommendations)
      rescue JSON::ParserError
        render json: { error: 'Invalid JSON', raw: @recommendations }, status: :bad_request
      rescue ActionController::ParameterMissing
        render json: { error: 'Missing param: query' }, status: :bad_request
      end

      private

      def recommendation_service
        @recommendation_service ||= Agents::RecommendationService.new
      end

      def clean_json(json)
        json.sub("```json\n", '').sub("\n```", '').strip
      end
    end
  end
end
