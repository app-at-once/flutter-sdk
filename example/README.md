# AppAtOnce SDK Examples

This directory contains comprehensive examples demonstrating all features of the AppAtOnce SDK for Flutter/Dart.

## Getting Started

### 1. Install Dependencies

First, make sure the SDK dependencies are installed:

```bash
# From the flutter-sdk root directory
flutter pub get
```

### 2. Configure Environment

Create a `.env` file with your API key:

```bash
echo "APPATONCE_API_KEY=your_actual_api_key_here" > .env
```

Or export it as an environment variable:
```bash
export APPATONCE_API_KEY=your_actual_api_key_here
```

### 3. Run Examples

Each example can be run individually:

```bash
dart run [example-file].dart
```

## Available Examples

### Core SDK Features

#### `basic_usage.dart`
Basic SDK initialization and simple operations.

#### `complete_sdk_example.dart`
Comprehensive example showcasing all major SDK features.

#### `query_builder.dart`
Demonstrates advanced query building capabilities for database operations.

#### `advanced_features.dart`
Showcases advanced SDK features including:
- Payment processing
- Image processing
- Document conversion
- Workflow system
- Logic flows
- Trigger system

### Authentication & Authorization

#### `auth.dart`
Complete authentication flow example:
- User signup and signin
- Token refresh
- Password reset
- Email verification
- Two-factor authentication

#### `oauth.dart`
OAuth implementation for both projects and apps:
- OAuth flow setup
- Token management
- Scope handling

### Communication Services

#### `email.dart`
Email service features:
- Transactional emails
- Email templates
- Bulk campaigns
- Analytics
- Contact management
- Suppression lists

#### `push_notifications.dart`
Push notification features:
- Device registration
- Sending notifications
- Topic management
- Scheduled notifications
- Rich notifications
- Campaign creation

### Document Processing

#### `pdf.dart`
PDF generation and manipulation:
- Generate from HTML/URL/Markdown
- Merge and split PDFs
- Add watermarks
- Extract text
- Compress PDFs

#### `ocr.dart`
Optical Character Recognition:
- Extract text from images/PDFs
- Multi-language support
- Table detection
- Receipt/invoice parsing
- ID card extraction
- Handwriting recognition

### Content Management

#### `content_management.dart`
Content operations:
- Create and manage content
- Multi-resource content
- Content versioning

### AI Features

#### `ai/` folder
See the [AI examples README](./ai/README.md) for details on:
- Text generation and chat
- Content creation
- Language processing
- Code assistance
- Image/audio/video generation
- And more...

## Getting Your API Key

1. Sign up at [https://appatonce.com](https://appatonce.com)
2. Create a new project
3. Copy your API key from the project settings

## Troubleshooting

### "API key not set" Error
Make sure you've either:
- Created a `.env` file with your API key
- Set the APPATONCE_API_KEY environment variable

### Connection Errors
- Make sure the AppAtOnce server is running
- The SDK uses the default URL configured in the package

### Authentication Errors
Ensure your API key is valid and has not expired.

## Need Help?

- Documentation: [https://docs.appatonce.com](https://docs.appatonce.com)
- Support: support@appatonce.com