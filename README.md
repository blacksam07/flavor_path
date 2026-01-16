# FlavorPath :spaghetti: <img width="512" height="512" alt="image" src="https://github.com/user-attachments/assets/0e8d87ed-a490-4021-adde-f209e6bf6870" />



[![Github Actions CI](https://github.com/rootstrap/rails_api_base/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/rootstrap/rails_api_base/actions)

FlavorPath is a Restaurant Recommendation API that use RAG (Retrieval Augmented Generation) to provide personalized restaurant recommendations based on user queries, this is a final project for the AI Development course at Rootstrap.

## Features

- Restaurant Recommendation API
- RAG (Retrieval Augmented Generation)
- LLM (Large Language Model)
- Embedding (Vectorization) Postgres extension


## How to use

1. Clone this repo
1. Install PostgreSQL and vector extension
1. Run `rails db:setup && rails db:seed` To get the initial data
1. Run `bin/dev`
1. You can now try your API using the defined endpoint

### Endpoints

- POST /api/v1/recommendations

### Request body

```json
{
    "query": "Suggest restaurants near downtown Chicago with vegetarian options, moderately priced, suitable for a family dinner."
}
```

### Response body

```json
[
	{
		"name": "Green Table",
		"neighborhood": "Loop",
		"price_level": 2,
		"reasons": [
			"Large vegetarian menu",
			"Family-friendly atmosphere",
			"Moderately priced entrees"
		],
		"evidence": [
			"Family-friendly spot in the Loop with a large vegetarian menu, casual atmosphere.",
			"Kids loved the veggie pasta. Great portions.",
			"Moderately priced, cozy for family dinners."
		],
		"match_score": 0.90
	},
	{
		"name": "River North Veggie Kitchen",
		"neighborhood": "River North",
		"price_level": 2,
		"reasons": [
			"Vegetarian-forward restaurant",
			"Multiple family-size platters",
			"Kids menu available"
		],
		"evidence": [
			"Vegetarian-forward restaurant with multiple family-size platters, kids menu available.",
			"Excellent vegetarian options and friendly staff."
		],
		"match_score": 0.85
	}
]
```
