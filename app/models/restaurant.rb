# frozen_string_literal: true

# == Schema Information
#
# Table name: restaurants
#
#  id           :bigint           not null, primary key
#  cuisine_tags :jsonb
#  description  :text
#  embedding    :vector(1536)
#  latitude     :float            not null
#  longitude    :float            not null
#  name         :string           not null
#  neighborhood :string
#  price_level  :integer          default("low")
#  reviews      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Restaurant < ApplicationRecord
  has_neighbors :embedding

  validates :name, :latitude, :longitude, presence: true

  enum :price_level, { low: 1, medium: 2, high: 3 }, default: :low
end
