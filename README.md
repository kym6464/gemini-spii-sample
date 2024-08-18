# gemini-spii-sample

This repo is a supplement to my forum post https://www.googlecloudcommunity.com/gc/AI-ML/Disable-Gemini-SPII/m-p/791679. It demonstrates Gemini 1.5 Pro returning the following error when using [JSON mode](https://ai.google.dev/gemini-api/docs/json-mode?lang=python):

> SPII: The token generation was stopped because the response was flagged for Sensitive Personally Identifiable Information (SPII) content.

The scripts in this repo use `gemini-1.5-pro` by default, but you can override it by setting the `MODEL_ID` env var.

## Set up your environment

The scripts in this repo send requests to the Gemini API in Vertex AI by using the REST API. You have to follow https://cloud.google.com/vertex-ai/generative-ai/docs/start/quickstarts/quickstart-multimodal#expandable-1 to setup your environment.

To verify that you have setup your environment properly, you can follow the [Send a text-only request](https://cloud.google.com/vertex-ai/generative-ai/docs/start/quickstarts/quickstart-multimodal#send-text-only-request) guide using the REST tab. Here's a more detailed version of it:

1. Make the script executable:

   ```bash
   chmod +x ./scripts/smoketest.sh
   ```

2. Run the script:

   ```bash
   ./scripts/smoketest.sh
   ```

3. Verify that the response you receive resembles [smoketest_response_body.json](./snapshots/smoketest_response_body.json)

## Example 1: Success

In this example, we send the model [document.jpg](./prompts/document.jpg) and [prompt_3.txt](./prompts/prompt_3.txt) and it successfully extracts the data we are interested in.

Input and output snapshots:

- [request body](./snapshots/example_1_request_body.json)
- [response body](./snapshots/example_1_response_body.json)

How to reproduce the above files:

1. Make the script executable:

   ```bash
   chmod +x ./scripts/extract_one.sh
   ```

2. Run the script:

   ```bash
   ./scripts/extract_one.sh ./prompts/document.jpg ./prompts/prompt_3.txt
   ```

## Example 2: SPII Error

In this example, we send the model the exact same information as the previous example but we also set [generationConfig.responseSchema](https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/inference#parameters) to [prompt_3_schema.json](./prompt_3_schema.json). The addition of a response schema causes the model to refuse the prompt due to SPII.

Input and output snapshots:

- [request body](./snapshots/example_2_request_body.json)
- [response body](./snapshots/example_2_response_body.json)

How to reproduce the above files:

(1) Make the script executable:

```bash
chmod +x ./scripts/extract_two.sh
```

(2) Run the script:

```bash
./scripts/extract_two.sh ./prompts/document.jpg ./prompts/prompt_3.txt ./prompts/prompt_3_schema.json
```
