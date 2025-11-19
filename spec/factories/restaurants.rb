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
FactoryBot.define do
  factory :restaurant do
    name { "MyString" }
    description { "MyText" }
    neighborhood { "MyString" }
    cuisine_tags { "" }
    price_level { 1 }
    latitude { 1.5 }
    longitude { 1.5 }
    reviews { "" }
  end
end
