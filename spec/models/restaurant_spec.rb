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
require 'rails_helper'

RSpec.describe Restaurant do
  pending "add some examples to (or delete) #{__FILE__}"
end
