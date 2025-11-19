# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.text :description
      t.string :neighborhood
      t.jsonb :cuisine_tags, default: []
      t.integer :price_level, default: 1
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.jsonb :reviews, default: []
      t.vector :embedding, limit: 1536

      t.timestamps
    end
  end
end
