#!/bin/bash

if [ -z "$PROJECT_ID" ]; then
  PROJECT_ID=$(gcloud config get-value project)
  if [ -z "$PROJECT_ID" ]; then
    echo "Error: Unable to determine PROJECT_ID. Please set it manually."
    exit 1
  fi
fi

MODEL_ID=${MODEL_ID:-"gemini-1.5-pro"}

if [ -f "$1" ]; then
  IMAGE_PATH=$1
else
  echo "Error: The first argument must be a .jpg file for the prompt."
  exit 1
fi

if [ -f "$2" ]; then
  PROMPT=$(cat "$2")
else
  echo "Error: The second argument must be a .txt file for the prompt."
  exit 1
fi

if [ -f "$3" ]; then
  PROMPT_SCHEMA=$(jq -c . < "$3")
else
  echo "Error: The third argument must be a .json file for the response schema."
  exit 1
fi

ACCESS_TOKEN=$(gcloud auth print-access-token)
IMAGE_BASE64=$(base64 < "$IMAGE_PATH" | tr -d '\n')
PROMPT_JSON=$(jq -n --arg text "$PROMPT" '$text')

echo '
===== <request body> =====
{
  "contents": {
    "role": "user",
    "parts": [
      {
        "inlineData": {
          "mimeType": "image/jpeg",
          "data": "'"${IMAGE_BASE64:0:10}..."'"
        }
      },
      {
        "text": '"${PROMPT_JSON}"'
      }
    ]
  },
  "generationConfig": {
    "responseMimeType": "application/json",
    "responseSchema": '"${PROMPT_SCHEMA}"'
  }
}
===== </request body> =====
'

curl -X POST \
-H "Authorization: Bearer ${ACCESS_TOKEN}" \
-H "Content-Type: application/json" \
"https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:streamGenerateContent" \
-d '{
  "contents": {
    "role": "user",
    "parts": [
      {
        "inlineData": {
          "mimeType": "image/jpeg",
          "data": "'"${IMAGE_BASE64}"'"
        }
      },
      {
        "text": '"${PROMPT_JSON}"'
      }
    ]
  },
  "generationConfig": {
    "responseMimeType": "application/json",
    "responseSchema": '"${PROMPT_SCHEMA}"'
  }
}'
