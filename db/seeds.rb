# frozen_string_literal: true
puts "Creating admin user..."
AdminUser.create!(email: 'admin@example.com', password: 'password') unless AdminUser.exists?(email: 'admin@example.com') if Rails.env.development?
Setting.create_or_find_by!(key: 'min_version', value: '0.0') unless Setting.exists?(key: 'min_version')

puts "Creating restaurants..."
restaurants = [
  {
    name: "Green Table",
    description: "Family-friendly spot in the Loop with a large vegetarian menu, casual atmosphere. Entrees $12–18.",
    neighborhood: "Loop",
    cuisine_tags: ["vegetarian", "american", "family-friendly"],
    price_level: 2,
    latitude: 41.8837,
    longitude: -87.6289,
    reviews: [
      { rating: 5, text: "Kids loved the veggie pasta. Great portions." },
      { rating: 4, text: "Moderately priced, cozy for family dinners." }
    ],
  },
  {
    name: "River North Veggie Kitchen",
    description: "Vegetarian-forward restaurant with multiple family-size platters, kids menu available.",
    neighborhood: "River North",
    cuisine_tags: ["vegetarian", "gluten-free options", "family"],
    price_level: 2,
    latitude: 41.8925,
    longitude: -87.6340,
    reviews: [
      { rating: 5, text: "Excellent vegetarian options and friendly staff." }
    ],
  },
  {
    name: "Loop Pizza House",
    description: "Classic pizza and pasta spot, some vegetarian pizzas, large tables for families. Entrees $10–20.",
    neighborhood: "Loop",
    cuisine_tags: ["italian", "pizza", "vegetarian options"],
    price_level: 1,
    latitude: 41.8810,
    longitude: -87.6270,
    reviews: [
      { rating: 4, text: "Affordable and very family friendly." }
    ],
  }
]

Restaurant.create!(restaurants)

puts "Created #{Restaurant.count} restaurants"
