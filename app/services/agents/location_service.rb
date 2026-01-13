# frozen_string_literal: true

module Agents
  class LocationService
    SYSTEM = <<~SYS
      You are a Geographic Normalization Agent.

      Your task is extract and convert a location written in natural language by a user into a clean, structured array of nearby neighborhoods.

      The user will provide a place such as:
      - a city ("Chicago")
      - a zone ("downtown Chicago", "midtown Manhattan")
      - a landmark ("near Union Square", "around Wrigley Field")
      - or a general area ("near the beach in Miami")

      You must infer the most likely geographic center and return the commonly accepted neighborhoods that surround or belong to that area.

      You should think like a local urban geographer, not like a GPS.

      Your output must follow these rules:

      1. Output format must be a valid JSON array of strings.
      2. Each string must be the official or commonly used neighborhood name.
      3. Use title case capitalization (e.g., "River North", not "river north").
      4. Do not include duplicates.
      5. Do not include boroughs, cities, or regions — only neighborhoods.
      6. Do not include explanations, comments, or markdown — only the array.
      7. Prefer neighborhoods that people actually use in real estate, dining, or navigation contexts.
      8. When in doubt, favor neighborhoods that locals would consider "part of" or "adjacent to" the given location.
    SYS

    # naive map for sample terms (expand as needed)
    PRESET_LOCATIONS = {
      'downtown chicago' => { neighborhoods: ['Loop', 'River North'], center: { lat: 41.8837, lng: -87.6278 },
                              radius_meters: 3000 },
      'loop' => { neighborhoods: ['Loop'], center: { lat: 41.8837, lng: -87.6278 }, radius_meters: 1500 }
    }.freeze
    def initialize(openai_client: OpenAIClient, model: ENV.fetch('OPENAI_CHAT_MODEL', 'gpt-4o-mini'))
      @client = openai_client
      @model = model
    end

    def neighborhoods(user_text)
      messages = [
        { role: 'system', content: SYSTEM },
        { role: 'user', content: user_text }
      ]

      resp = @client.chat.completions.create!(messages: messages, model: @model, max_tokens: 800)
      JSON.parse(resp.choices.first.message.content)
    end

    def parse(user_text)
      text = user_text.downcase
      PRESET_LOCATIONS.each do |k, v|
        return v if text.include?(k)
      end

      # fallback: ask for clarification in production; here we return nils
      { neighborhoods: [], center: nil, radius_meters: 5000 }
    end
  end
end
