# AI Examples

This directory contains separate examples for each AI feature category. Each file demonstrates specific AI capabilities without timeouts.

## Prerequisites

1. Make sure you have the SDK dependencies installed:
```bash
cd ../.. && flutter pub get
```

2. Set your API key:
```bash
export APPATONCE_API_KEY=your_api_key_here
```

Or create a `.env` file in the example directory

## Running Examples

Each example can be run independently:

### Text-Based AI Features (01-08)

#### 1. Text Generation
Basic text generation and chat conversations.
```bash
dart run ai/01_text_generation.dart
```

#### 2. Content Creation
Blog posts, captions, scripts, hashtags, and content optimization.
```bash
dart run ai/02_content_creation.dart
```

#### 3. Language Processing
Translation, summarization, writing enhancement, and moderation.
```bash
dart run ai/03_language_processing.dart
```

#### 4. Code Assistance
Code generation and analysis for multiple languages.
```bash
dart run ai/04_code_assistance.dart
```

#### 5. Reasoning & Problem Solving
Mathematical problems, logic puzzles, and step-by-step solutions.
```bash
dart run ai/05_reasoning_solving.dart
```

#### 6. Email Intelligence
Email reply generation and subject line optimization.
```bash
dart run ai/06_email_intelligence.dart
```

#### 7. Natural Language Processing
Entity extraction, sentiment analysis, and keyword extraction.
```bash
dart run ai/07_nlp_features.dart
```

#### 8. Embeddings
Generate text embeddings for similarity comparison and semantic search.
```bash
dart run ai/08_embeddings.dart
```

### Unified AI Features (10-13)

#### 10. Unified AI Complete Example
Comprehensive example showing all AI capabilities in one file.
```bash
dart run ai/10_unified_ai_complete.dart
```

#### 11. Image Generation
AI-powered image generation from text prompts.
```bash
dart run ai/11_image_generation.dart
```

#### 12. Audio Generation
AI-powered audio generation and text-to-speech.
```bash
dart run ai/12_audio_generation.dart
```

#### 13. Video Generation
AI-powered video generation from text prompts.
```bash
dart run ai/13_video_generation.dart
```

## Quick Test All

To run all examples sequentially:
```bash
dart run ai/run_all.dart
```

## Features by Category

### Text-Based AI Features

| Category | Features | Example File |
|----------|----------|--------------|
| **Text Generation** | Text generation, Chat (single/multi-turn) | 01_text_generation.dart |
| **Content Creation** | Blog posts, Captions, Scripts, Hashtags, Analysis, Ideas, Optimization | 02_content_creation.dart |
| **Language Processing** | Translation, Summarization, Enhancement, Moderation | 03_language_processing.dart |
| **Code Assistance** | Code generation, Code analysis | 04_code_assistance.dart |
| **Reasoning** | Problem solving, Step-by-step explanations | 05_reasoning_solving.dart |
| **Email** | Reply generation, Subject optimization | 06_email_intelligence.dart |
| **NLP** | Entity extraction, Sentiment analysis, Keywords | 07_nlp_features.dart |
| **Embeddings** | Text embeddings, Similarity comparison | 08_embeddings.dart |

### Multimedia AI Features

| Category | Features | Example File |
|----------|----------|--------------|
| **Unified Example** | All AI features in one comprehensive example | 10_unified_ai_complete.dart |
| **Image Generation** | Text-to-image, Style transfer, Image editing | 11_image_generation.dart |
| **Audio Generation** | Text-to-speech, Voice synthesis, Audio effects | 12_audio_generation.dart |
| **Video Generation** | Text-to-video, Video editing, Animation | 13_video_generation.dart |

## Tips

- Each example is self-contained and can be modified independently
- Examples include error handling and detailed output
- Response times may vary based on the complexity of the operation
- Some features may have token limits or rate limits

## Troubleshooting

If you encounter errors:

1. **API Key Issues**: Ensure your API key is correctly set
2. **Connection Errors**: Verify the server is accessible
3. **Timeout Issues**: These examples are designed to avoid timeouts by focusing on specific features
4. **Response Format Issues**: The examples handle various response formats from the server

## Adding New Examples

To add a new AI feature example:

1. Create a new file following the naming pattern: `XX_feature_name.dart`
2. Use the same structure as existing examples
3. Include proper error handling
4. Update this README with the new example