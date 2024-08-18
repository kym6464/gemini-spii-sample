#!/bin/bash

if [ -z "$PROJECT_ID" ]; then
  PROJECT_ID=$(gcloud config get-value project)
  if [ -z "$PROJECT_ID" ]; then
    echo "Error: Unable to determine PROJECT_ID. Please set it manually."
    exit 1
  fi
fi

MODEL_ID=${MODEL_ID:-"gemini-1.5-pro"}
ACCESS_TOKEN=$(gcloud auth print-access-token)

curl -X POST \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-H "Content-Type: application/json" \
"https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:streamGenerateContent" \
-d '{
  "contents": {
    "role": "user",
    "parts": [
      {
        "text": "What'\''s a good name for a flower shop that specializes in selling bouquets of dried flowers?"
      }
    ]
  }
}'