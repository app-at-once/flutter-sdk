# AppAtOnce Flutter SDK

> [!CAUTION]
> ## 🚨 **PREVIEW MODE** 🚨
> **This is a development preview. Data may be reset. Not for production use.**
> 
> ---

**🔗 <a href="https://appatonce.com" target="_blank">https://appatonce.com</a>**

The official Flutter SDK for AppAtOnce - the unified backend platform that combines database, real-time features, AI processing, storage, email, and workflows into one powerful, code-first SDK.

## 🌟 Why AppAtOnce?

**One SDK. Infinite Possibilities.**

- **🚀 Code-First Database** - Define schemas, query with intuitive syntax, real-time subscriptions
- **🤖 Built-in AI** - Text generation, image creation, embeddings, content analysis
- **⚡ Real-Time Everything** - Database changes, pub/sub channels, presence tracking
- **📦 Smart Storage** - File uploads, image processing, CDN integration
- **📧 Email & Push** - Templates, campaigns, multi-platform notifications
- **🔧 Workflow Engine** - Visual workflows, triggers, automation

## Think More. Build Faster.

Instead of integrating 10+ services (database, cache, file storage, AI APIs, email service, real-time server), use one SDK:

```dart
// Traditional approach - multiple services, complex setup
final db = DatabaseClient();
final cache = CacheClient();
final storage = StorageClient();
final ai = AIClient();
final email = EmailClient();
final realtime = RealtimeClient();
// ... and more configuration

// AppAtOnce approach - one client, everything included
final client = AppAtOnceClient(apiKey: 'your-api-key');
// Database, AI, storage, email, real-time - all ready to use
```

## Feature Status

### ✅ Fully Implemented

#### 🗄️ Database Operations
- **New Intuitive WHERE Syntax** - Multiple ways to write conditions
- **Fluent Query Builder** - Chaining, joins, aggregations, pagination
- **Schema Management** - Create/modify tables, indexes, constraints
- **Transactions & Batch Operations** - ACID compliance
- **Search Integration** - Text search with filtering support

#### ⚡ Real-time Features
- **Database Subscriptions** - Live updates on INSERT/UPDATE/DELETE
- **Channel Messaging** - Pub/sub for custom events
- **Presence Tracking** - Collaborative features with user status
- **Auto-reconnection** - Robust connection management
- **Workflow & Analytics Events** - Real-time monitoring

#### 🤖 AI Integration
- **Text Generation** - Multiple AI models and providers supported
- **Image Generation** - AI-powered image creation with various models
- **Audio Generation** - Text-to-speech, voice cloning
- **Video Generation** - AI video creation (async)
- **Embeddings** - Vector embeddings for semantic search
- **Content Analysis** - Sentiment, SEO, readability scoring

#### 📦 Storage & File Management
- **Simple Upload API** - Intuitive `upload()` method
- **File Management** - List, delete, copy, move operations
- **Image Processing** - Resize, optimize, watermarks
- **Public URLs** - Direct file access
- **Bucket Management** - Create, configure, manage buckets

#### 📧 Email & Communications
- **Template System** - Rich templates with variables
- **Campaign Management** - Bulk email sending
- **Contact Lists** - Organize and segment contacts
- **Analytics** - Open rates, click tracking

#### 🔐 Authentication & Security
- **Multi-tenant Auth** - Project-specific user databases
- **OAuth Integration** - Social login providers
- **API Key Management** - Granular permissions
- **Session Management** - Secure token handling

#### 🔧 Workflow Engine
- **Visual Workflows** - Drag-and-drop workflow builder
- **Database Triggers** - Auto-processing on data changes
- **Multi-step Logic** - Complex business rules
- **Event Monitoring** - Real-time execution tracking

#### 🔍 Additional Features
- **Push Notifications** - Multi-platform support
- **Document Processing** - PDF, OCR, format conversion
- **Image Processing** - Advanced manipulation
- **Payment Integration** - Multiple payment providers supported

### 🔄 In Development

- **Logic Server** - Client-side logic execution (partial implementation)
- **Advanced Search** - Full semantic search with vector databases
- **Analytics Dashboard** - Real-time metrics and insights

### 📋 Planned Features

- **GraphQL API** - Auto-generated GraphQL endpoints
- **Edge Functions** - Serverless function deployment
- **Advanced Security** - Row-level security, field encryption
- **Compliance Tools** - GDPR helpers, audit logging

## Core Examples

### 🆕 New Intuitive Database Operations

```dart
// Multiple WHERE syntax options - choose what feels natural

// 1. Simple equality (most common)
final user = await client.table('users')
  .where('id', userId)  // defaults to equals
  .first();

// 2. With operator
final recentPosts = await client.table('posts')
  .where('created_at', '>', '2024-01-01')
  .orderBy('created_at', ascending: false)
  .execute();

// 3. Object syntax for multiple conditions
final activeUsers = await client.table('users')
  .where({'is_active': true, 'subscription_tier': 'pro'})
  .execute();

// 4. Chain conditions with .and()
final filteredData = await client.table('workspaces')
  .where('is_active', true)
  .and('max_members', '>=', 10)
  .execute();

// 5. Use .filter() alias (same as .where())
final results = await client.table('products')
  .filter('category', 'electronics')
  .execute();
```

### Schema Management

```dart
// Create table with intelligent defaults
final result = await client.schema.createTable(
  TableSchema(
    name: 'products',
    columns: [
      ColumnDefinition(name: 'id', type: 'uuid', primaryKey: true),
      ColumnDefinition(name: 'name', type: 'varchar', required: true),
      ColumnDefinition(name: 'price', type: 'decimal', precision: 10, scale: 2),
      ColumnDefinition(name: 'description', type: 'text'),
      ColumnDefinition(name: 'created_at', type: 'timestamp', defaultValue: 'now()'),
    ],
    indexes: [
      IndexDefinition(name: 'idx_products_name', columns: ['name']),
      IndexDefinition(name: 'idx_products_price', columns: ['price']),
    ],
  ),
);

print('✅ Table created: ${result.tableName}');
```

## Installation

```bash
flutter pub add appatonce
```

Or add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  appatonce: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## 📊 Schema Migration System

AppAtOnce provides a powerful schema migration system that allows you to define your database schema in code and automatically sync it with your database.

> [!CAUTION]
> **Migration Safety**
> - By default, migrations run in **safe mode** - they will NOT drop columns or tables
> - Use development mode for column drops and type changes
> - Always use dry run first to preview changes
> - The force mode will DROP ALL TABLES - use with extreme caution!

### Quick Start

```dart
// Define your schema
final schema = {
  'users': TableSchema(
    name: 'users',
    columns: [
      ColumnDefinition(name: 'id', type: 'uuid', primaryKey: true, defaultValue: 'gen_random_uuid()'),
      ColumnDefinition(name: 'email', type: 'varchar', unique: true, required: true),
      ColumnDefinition(name: 'name', type: 'varchar'),
      ColumnDefinition(name: 'created_at', type: 'timestamp', defaultValue: 'now()'),
    ],
    indexes: [
      IndexDefinition(name: 'idx_users_email', columns: ['email'], unique: true),
    ],
  ),
  'posts': TableSchema(
    name: 'posts',
    columns: [
      ColumnDefinition(name: 'id', type: 'uuid', primaryKey: true, defaultValue: 'gen_random_uuid()'),
      ColumnDefinition(name: 'user_id', type: 'uuid', required: true, 
        references: ForeignKeyReference(table: 'users', onDelete: 'CASCADE')),
      ColumnDefinition(name: 'title', type: 'varchar', required: true),
      ColumnDefinition(name: 'content', type: 'text'),
      ColumnDefinition(name: 'created_at', type: 'timestamp', defaultValue: 'now()'),
    ],
  ),
};

// Run migration
final result = await client.schema.migrate(schema, 
  dryRun: false,
  dev: false, // Set to true for development mode
);

print('Migration ${result.success ? "succeeded" : "failed"}');
```

### Migration Modes

#### 1. **Production Mode (Default)**
Safe mode that prevents data loss.

```dart
await client.schema.migrate(schema);
```

✅ **Can do:**
- Create new tables
- Add new columns to existing tables
- Create indexes
- Add foreign key relationships

❌ **Cannot do:**
- Drop columns
- Drop tables
- Change column types
- Modify existing constraints

#### 2. **Development Mode**
Allows schema modifications that may cause data loss.

```dart
await client.schema.migrate(schema, dev: true);
```

✅ **Additionally can:**
- Drop columns that are removed from schema
- Drop tables that are removed from schema
- Change column types (with automatic conversion)
- Modify column constraints

> [!WARNING]
> Development mode can cause data loss! Always backup your data first.

### Column Types

| Type | PostgreSQL Type | Description |
|------|----------------|-------------|
| `varchar` | VARCHAR(255) | Variable-length string |
| `text` | TEXT | Unlimited text |
| `integer` | INTEGER | 32-bit integer |
| `bigint` | BIGINT | 64-bit integer |
| `float` | REAL | Single precision |
| `double` | DOUBLE PRECISION | Double precision |
| `decimal` | DECIMAL(10,2) | Fixed precision |
| `boolean` | BOOLEAN | true/false |
| `date` | DATE | Date only |
| `time` | TIME | Time only |
| `timestamp` | TIMESTAMP | Date and time |
| `timestamptz` | TIMESTAMPTZ | Date, time with timezone |
| `uuid` | UUID | Universally unique identifier |
| `json` | JSON | JSON data |
| `jsonb` | JSONB | Binary JSON (recommended) |

### Best Practices

1. **Always use dry run first** to preview changes
2. **Test migrations in development** before production
3. **Version control your schema** - commit schema definitions to git
4. **Use timestamps** - add created_at/updated_at to tables
5. **Plan column type changes** - they require dev mode
6. **Backup before destructive operations** - especially with dev mode
7. **Use meaningful defaults** - helps with migrations
8. **Document schema changes** - comment your schema definitions

## Quick Start

### Get Your API Key

🔑 **Your APPATONCE_API_KEY is automatically generated when you create a project in AppAtOnce**

**Two ways to get your API key:**

1. **Quick Setup** (Recommended for developers):
   - Visit <a href="https://appatonce.com/login" target="_blank">https://appatonce.com/login</a>
   - Sign up or log in to your account
   - Create a new project manually
   - Copy your API key from the project dashboard

2. **No-Code App Creation** (Build complete apps instantly):
   - Visit <a href="https://appatonce.com" target="_blank">https://appatonce.com</a>
   - Describe your app idea in natural language
   - AppAtOnce generates a complete application
   - Your API key is provided with the generated project for further customization

💡 **Both methods give you the same powerful API key** - choose the approach that fits your workflow!

```dart
import 'package:appatonce/appatonce.dart';

void main() async {
  // Initialize the SDK
  // Initialize the client
  final client = AppAtOnceClient(apiKey: 'your-api-key-here');

  // Create a table
  await client.schema.createTable(
    TableSchema(
      name: 'todos',
      columns: [
        ColumnDefinition(name: 'id', type: 'uuid', primaryKey: true),
        ColumnDefinition(name: 'title', type: 'varchar', nullable: false),
        ColumnDefinition(name: 'completed', type: 'boolean', defaultValue: false),
        ColumnDefinition(name: 'created_at', type: 'timestamp', defaultValue: 'now()'),
      ],
    ),
  );

  // Insert data
  final todo = await client.data.insert('todos', {
    'title': 'Build amazing app with AppAtOnce',
    'completed': false,
  });

  // Query data with real-time updates
  client.realtime
    .from('todos')
    .on(RealtimeEvent.all, (payload) {
      print('Todo changed: ${payload.eventType} - ${payload.data}');
    })
    .subscribe();

  print('Todo created: ${todo['id']}');
}
```

### 🤖 AI Features

AppAtOnce provides a comprehensive AI suite powered by advanced language models. All AI features are optimized for quality, speed, and reliability.

**Available Text-Based AI Features:**
- ✅ Text Generation & Chat
- ✅ Translation (multiple languages)
- ✅ Text Summarization (paragraph, bullet, brief)
- ✅ Writing Enhancement (grammar, tone, style)
- ✅ Content Moderation (safety checks)
- ✅ Code Generation & Analysis
- ✅ Problem Solving & Reasoning
- ✅ Email Intelligence (replies, subjects)
- ✅ Natural Language Processing (entities, sentiment, keywords)
- ✅ Content Creation (blog posts, captions, scripts, hashtags)
- ✅ Content Analysis & Optimization
- ✅ Content Idea Generation

#### Text Generation & Chat

```dart
// Basic text generation
final result = await client.ai.generateText(
  'Write a short greeting for a software development team',
  temperature: 0.7,
  maxTokens: 100,
);
print(result.result);

// Build custom chat experiences with full control
final chatResponse = await client.ai.chat([
  {'role': 'system', 'content': 'You are a helpful coding assistant specialized in Dart.'},
  {'role': 'user', 'content': 'How do I handle errors in async functions?'}
]);
print(chatResponse.result);
```

#### 🎨 Unified Image Generation (Queue-Based)

**Advanced AI-powered image generation with multiple models and async processing:**

```dart
// Generate image with queue-based processing
final imageJob = await client.ai.generateImage(
  'A futuristic cityscape at sunset with flying cars',
  width: 1024,
  height: 1024,
  model: 'SDXL', // 'SD3', 'SDXL', 'SD1.5', 'Playground2.5', 'FLUX.1'
  negativePrompt: 'low quality, blurry',
  steps: 30,
  cfg: 7.5,
  seed: 12345, // For reproducible results
);

// Check job status
final status = await client.ai.getImageJobStatus(imageJob.jobId);
if (status.status == 'completed') {
  print('Image URL: ${status.results['url']}');
  print('Cost: ${status.results['cost']}');
}
```

#### 🎬 Unified Video Generation (With AI Narration)

```dart
// Generate video with narration
final videoJob = await client.ai.generateVideo(
  'A tour of a modern smart home',
  duration: 10, // 6 or 10 seconds
  aspectRatio: '16:9', // '16:9', '9:16', '1:1'
  resolution: '1080p',
  voiceEnabled: true,
  voiceText: 'Welcome to the future of smart living...',
  voice: 'nova', // OpenAI voices
  voiceSpeed: 1.0,
  voiceProvider: 'openai', // or 'elevenlabs'
);
```

#### 🎵 Unified Audio Generation (Multiple Providers)

```dart
// Generate audio with OpenAI
final audioJob = await client.ai.generateAudio(
  'Welcome to AppAtOnce!',
  voice: 'nova', // 'alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'
  provider: 'openai',
  model: 'tts-1-hd', // High quality
  speed: 1.0, // 0.25 to 4.0
);
```

### 📦 Simple Storage API

```dart
// Simple upload - just works!
final publicUrl = await client.storage.upload(
  'user-uploads',
  file,  // File object from input
  'avatars/profile.jpg'
);

print('Uploaded to: $publicUrl');
// Output: https://cdn.appatonce.com/user-uploads/avatars/profile.jpg
```

### ⚡ Real-time Features

```dart
// Subscribe to database changes
final subscription = client.realtime
  .from('workspaces')
  .on(RealtimeEvent.all, (payload) {
    print('→ ${payload.eventType}: ${payload.data['name']}');
    
    switch (payload.eventType) {
      case 'INSERT':
        print('  💡 New workspace created');
        break;
      case 'UPDATE':
        print('  📝 Workspace updated');
        break;
      case 'DELETE':
        print('  🗑️ Workspace deleted');
        break;
    }
  })
  .subscribe();
```

### 📧 Email & Communications

```dart
// Create email template with variables
final template = await client.email.createTemplate(
  name: 'welcome-email',
  subject: 'Welcome to {{company_name}}!',
  html: '''
    <h1>Welcome {{user_name}}!</h1>
    <p>Thanks for joining {{company_name}}.</p>
    <a href="{{activation_link}}">Get Started</a>
  ''',
  variables: [
    TemplateVariable(name: 'company_name', type: 'string', required: true),
    TemplateVariable(name: 'user_name', type: 'string', required: true),
    TemplateVariable(name: 'activation_link', type: 'string', required: true),
  ],
);

print('✅ Template created: ${template.name}');
```

## 📚 Core Concepts

### Client Initialization

```dart
// Basic initialization
final client = AppAtOnceClient(
  apiKey: 'your-api-key',
);

// Advanced configuration
final client = AppAtOnceClient(
  apiKey: 'your-api-key',
  baseUrl: 'https://custom.appatonce.com',
  timeout: Duration(seconds: 30),
  retries: 3,
  headers: {
    'X-App-Version': '1.0.0',
    'X-Platform': Platform.operatingSystem,
  },
  debug: true, // Enable request/response logging
);

// Listen to authentication state
client.auth.sessionStream.listen((session) {
  if (session != null) {
    print('User logged in: ${session.user.email}');
  } else {
    print('User logged out');
  }
});
```

### Database Operations

Build complex queries with our intuitive fluent API:

```dart
// Simple query
final users = await client.data
  .from('users')
  .select('*')
  .execute();

// Advanced query with joins
final posts = await client.data
  .from('posts')
  .select('''
    id,
    title,
    content,
    author:users!author_id(
      id,
      name,
      avatar_url
    ),
    comments:post_comments(
      id,
      content,
      user:users(name)
    )
  ''')
  .eq('published', true)
  .order('created_at', ascending: false)
  .limit(10)
  .execute();

// Transactions
await client.transaction((tx) async {
  // All operations in this block are atomic
  final user = await tx.data.insert('users', userData);
  await tx.data.insert('profiles', {
    ...profileData,
    'user_id': user['id'],
  });
});
```

### Real-time Subscriptions

```dart
// Table-level subscriptions
final subscription = client.realtime
  .from('messages')
  .filter('room_id', 'eq', roomId)
  .on(RealtimeEvent.insert, (payload) {
    // Handle new message
    addMessageToUI(payload.data);
  })
  .subscribe();

// Channel-based pub/sub
final channel = client.realtime.channel('game:${gameId}');

channel.on('player_move', (payload) {
  updatePlayerPosition(payload.data);
});

channel.on('game_over', (payload) {
  showGameOverScreen(payload.data);
});

await channel.subscribe();

// Broadcast events
await channel.send('player_move', {
  'player_id': playerId,
  'position': {'x': 100, 'y': 200},
});
```

### Authentication

```dart
// Email/Password authentication
try {
  final session = await client.auth.signUp(
    email: 'user@example.com',
    password: 'SecurePass123!',
    metadata: {'referral_code': 'FRIEND123'},
  );
  
  // Email verification sent automatically
  print('Check your email to verify your account');
} on AppAtOnceException catch (e) {
  if (e.code == 'user_exists') {
    print('User already exists, try logging in');
  }
}

// OAuth authentication
final authUrl = await client.auth.signInWithOAuth(
  provider: OAuthProvider.google,
  redirectTo: 'myapp://auth/callback',
  scopes: ['email', 'profile'],
);

// Open in browser
await launchUrl(Uri.parse(authUrl));

// Magic link authentication
await client.auth.sendMagicLink(
  email: 'user@example.com',
  redirectTo: 'myapp://auth/magic',
);
```

### File Storage

```dart
// Upload with automatic optimization
final result = await client.storage.upload(
  bucket: 'avatars',
  file: StorageFile(
    path: 'profile.jpg',
    bytes: imageBytes,
    mimeType: 'image/jpeg',
  ),
  options: UploadOptions(
    transform: ImageTransform(
      width: 500,
      height: 500,
      fit: 'cover',
      quality: 85,
    ),
    variants: [
      ImageVariant(name: 'thumb', width: 100, height: 100),
      ImageVariant(name: 'medium', width: 300, height: 300),
    ],
  ),
);

print('Original: ${result.url}');
print('Thumbnail: ${result.variants['thumb']}');
```

## 🔥 Real-world Examples

### Build a Chat App

```dart
class ChatService {
  final AppAtOnceClient client;
  final channel = client.realtime.channel('chat:general');
  
  Future<void> sendMessage(String text) async {
    // Save to database
    final message = await client.data.insert('messages', {
      'text': text,
      'user_id': client.auth.currentUser!.id,
      'channel': 'general',
    });
    
    // Broadcast to channel
    await channel.send('new_message', message);
  }
  
  void listenToMessages(Function(Message) onMessage) {
    channel.on('new_message', (payload) {
      onMessage(Message.fromJson(payload.data));
    });
  }
}
```

### E-commerce Backend

```dart
class EcommerceService {
  final AppAtOnceClient client;
  
  Future<Order> createOrder(List<CartItem> items) async {
    return await client.transaction((tx) async {
      // Create order
      final order = await tx.data.insert('orders', {
        'user_id': client.auth.currentUser!.id,
        'status': 'pending',
        'total': calculateTotal(items),
      });
      
      // Add order items
      for (final item in items) {
        await tx.data.insert('order_items', {
          'order_id': order['id'],
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.price,
        });
        
        // Update inventory
        await tx.data
          .from('products')
          .update({'stock': {'decrement': item.quantity}})
          .eq('id', item.productId)
          .execute();
      }
      
      // Send confirmation email
      await client.email.sendTemplate(
        templateId: 'order-confirmation',
        to: [EmailRecipient(email: client.auth.currentUser!.email)],
        variables: {
          'order_number': order['id'],
          'items': items.map((i) => i.toJson()).toList(),
          'total': order['total'],
        },
      );
      
      return Order.fromJson(order);
    });
  }
}
```

### Content Management System

```dart
class CMSService {
  final AppAtOnceClient client;
  
  // Create and manage blog posts
  Future<ContentItem> createBlogPost({
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    final post = await client.content.create(
      resourceId: 'blog',
      resourceType: 'website',
      contentType: 'post',
      title: title,
      content: {
        'body': content,
        'tags': tags,
        'author': client.auth.currentUser!.name,
        'readTime': calculateReadTime(content),
      },
      metadata: {
        'seo': {
          'title': title,
          'description': content.substring(0, 160),
          'keywords': tags,
        },
      },
      status: 'draft',
    );
    
    return post;
  }
  
  // Publish content with version tracking
  Future<ContentItem> publishContent(String contentId) async {
    return await client.content.publish(contentId);
  }
  
  // Search and filter content
  Future<ContentListResponse> searchContent(String query) async {
    return await client.content.search(
      query,
      contentType: 'post',
      page: 1,
      limit: 20,
    );
  }
  
  // Manage content versions
  Future<void> rollbackContent(String contentId, int version) async {
    await client.content.restoreVersion(contentId, version);
  }
}
```

### AI-Powered Features with Unified Services

```dart
class AIService {
  final AppAtOnceClient client;
  
  Future<ProductContent> generateProductContent(Product product) async {
    // Generate product images with job tracking
    final mainImageJob = await client.ai.generateImage(
      'Professional product photo of ${product.name}',
      width: 1024,
      height: 1024,
      model: 'SDXL',
      steps: 40,
    );
    
    // Generate marketing video with AI narration
    final videoJob = await client.ai.generateVideo(
      'Product showcase for ${product.name}',
      duration: 10,
      voiceEnabled: true,
      voiceText: product.description,
      voice: 'nova',
    );
    
    // Generate voice-over for ads
    final audioJob = await client.ai.generateAudio(
      'Introducing ${product.name} - ${product.tagline}',
      voice: 'echo',
      provider: 'openai',
      speed: 1.1,
    );
    
    // Wait for image completion
    AIJobStatus? imageStatus;
    while (true) {
      imageStatus = await client.ai.getImageJobStatus(mainImageJob.jobId);
      if (imageStatus.status == 'completed') break;
      await Future.delayed(Duration(seconds: 2));
    }
    
    // Save to content management
    final content = await client.content.create(
      resourceId: 'products',
      resourceType: 'catalog',
      contentType: 'product',
      title: product.name,
      content: {
        'description': product.description,
        'mainImage': imageStatus.results['url'],
        'price': product.price,
        'features': product.features,
      },
      metadata: {
        'aiGenerated': true,
        'jobs': {
          'image': mainImageJob.jobId,
          'video': videoJob.jobId,
          'audio': audioJob.jobId,
        },
      },
    );
    
    return ProductContent(
      contentId: content.id,
      imageUrl: imageStatus.results['url'],
      videoJobId: videoJob.jobId,
      audioJobId: audioJob.jobId,
    );
  }
  
  // Batch generate product variations
  Future<List<String>> generateProductVariations(String baseProduct) async {
    final variations = [
      '$baseProduct in Arctic Blue',
      '$baseProduct in Forest Green',
      '$baseProduct in Sunset Red',
    ];
    
    final batchJob = await client.ai.generateBatchImages(
      variations,
      width: 800,
      height: 800,
      model: 'SDXL',
    );
    
    // Monitor batch progress
    print('Generating ${batchJob.totalImages} variations...');
    return [batchJob.jobId];
  }
}
```

## 🛠️ Advanced Configuration

### Environment-based Setup

```dart
// Development
final devClient = AppAtOnceClient(
  apiKey: const String.fromEnvironment('APPATONCE_API_KEY'),
  baseUrl: const String.fromEnvironment(
    'APPATONCE_URL',
    defaultValue: 'https://dev.appatonce.com',
  ),
  debug: true,
);

// Production
final prodClient = AppAtOnceClient(
  apiKey: dotenv.env['APPATONCE_API_KEY']!,
  baseUrl: dotenv.env['APPATONCE_URL']!,
  timeout: Duration(seconds: 60),
  retries: 5,
  debug: false,
);

// Custom interceptors
client.addInterceptor(
  onRequest: (request) {
    request.headers['X-Request-ID'] = generateRequestId();
    return request;
  },
  onResponse: (response) {
    logAnalytics('api_call', {
      'endpoint': response.requestOptions.path,
      'duration': response.duration,
      'status': response.statusCode,
    });
    return response;
  },
);
```

### Performance Optimization

```dart
// Connection pooling
final client = AppAtOnceClient(
  apiKey: 'your-api-key',
  connectionPool: ConnectionPoolConfig(
    maxConnections: 10,
    idleTimeout: Duration(minutes: 5),
  ),
);

// Request batching
final batch = client.createBatch();
batch.add(client.data.from('users').select('*'));
batch.add(client.data.from('posts').select('*').limit(10));
batch.add(client.data.from('comments').select('*').limit(20));

final results = await batch.execute();

// Caching
client.enableCache(
  duration: Duration(minutes: 5),
  maxSize: 100, // MB
  excludePaths: ['/auth/*', '/realtime/*'],
);
```

## 🧪 Testing

### Unit Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AppAtOnce SDK Tests', () {
    late AppAtOnceClient client;
    late MockHttpClient mockHttp;

    setUp(() {
      mockHttp = MockHttpClient();
      client = AppAtOnceClient.withMockClient(mockHttp);
    });

    test('should authenticate user', () async {
      when(mockHttp.post('/auth/login', any))
        .thenAnswer((_) async => {
          'session': {'access_token': 'token', 'user': {}}
        });

      final session = await client.auth.signIn(
        email: 'test@example.com',
        password: 'password',
      );

      expect(session.accessToken, equals('token'));
    });
  });
}
```

### Integration Testing

```dart
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Tests', () {
    late AppAtOnceClient client;

    setUpAll(() async {
      client = AppAtOnceClient(
        apiKey: 'test-api-key',
        baseUrl: 'http://localhost:8080',
      );
    });

    testWidgets('complete user flow', (tester) async {
      // Test your complete app flow
      await tester.pumpWidget(MyApp(client: client));
      
      // Interact with your app
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      
      // Verify results
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

## 🎯 Performance Tips

1. **Use Selective Queries**: Only request the fields you need
   ```dart
   // Good
   client.data.from('users').select('id, name, email')
   
   // Avoid
   client.data.from('users').select('*')
   ```

2. **Implement Pagination**: For large datasets
   ```dart
   final paginator = client.data.from('posts').paginate(
     pageSize: 20,
     prefetchPages: 2,
   );
   
   await for (final page in paginator) {
     processPage(page);
   }
   ```

3. **Use Indexes**: Create indexes for frequently queried fields
   ```dart
   await client.schema.createIndex(
     'users',
     IndexDefinition(
       name: 'idx_email',
       columns: ['email'],
       unique: true,
     ),
   );
   ```

4. **Cache Static Data**: Reduce API calls
   ```dart
   final categories = await getCachedOrFetch(
     'categories',
     () => client.data.from('categories').select('*').execute(),
     duration: Duration(hours: 1),
   );
   ```

## 📱 Platform-Specific Features

### iOS

```dart
// iOS-specific configuration
if (Platform.isIOS) {
  client.configurePushNotifications(
    iosSettings: IOSNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    ),
  );
}
```

### Android

```dart
// Android-specific configuration
if (Platform.isAndroid) {
  client.configurePushNotifications(
    androidSettings: AndroidNotificationSettings(
      channelId: 'default',
      channelName: 'Default Notifications',
      importance: Importance.high,
      enableVibration: true,
    ),
  );
}
```

### Web

```dart
// Web-specific features
if (kIsWeb) {
  client.enableWebWorkers();
  client.configurePersistence(
    storage: WebStorage.localStorage,
    encryptionKey: 'your-encryption-key',
  );
}
```

## 🤝 Error Handling

### Comprehensive Error Handling

```dart
class AppAtOnceService {
  final AppAtOnceClient client;
  
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int retries = 0;
    Duration delay = initialDelay;
    
    while (retries < maxRetries) {
      try {
        return await operation();
      } on AppAtOnceException catch (e) {
        if (e.code == 'rate_limit_exceeded') {
          await Future.delayed(Duration(seconds: e.retryAfter ?? 60));
          continue;
        } else if (e.code == 'network_error' && retries < maxRetries - 1) {
          await Future.delayed(delay);
          delay *= 2; // Exponential backoff
          retries++;
          continue;
        }
        rethrow;
      }
    }
    
    throw MaxRetriesExceededException();
  }
}
```

## Environment Configuration

### Environment Variables

```bash
# Set your API key
export APPATONCE_API_KEY=your-api-key-here
```

🔑 **How to get your API key:**
- **For Developers**: Visit <a href="https://appatonce.com/login" target="_blank">https://appatonce.com/login</a> → Create Project → Copy API Key
- **For No-Code Users**: Generate a complete app at <a href="https://appatonce.com" target="_blank">https://appatonce.com</a> and get your API key with the project

💡 **Your API key is automatically generated when you create any project in AppAtOnce** - whether through manual setup or no-code app generation.

### Using Environment Variables in Flutter

```dart
// Using flutter_dotenv package
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Load environment variables
await dotenv.load(fileName: ".env");

// Initialize client
final client = AppAtOnceClient(
  apiKey: dotenv.env['APPATONCE_API_KEY']!,
);
```

### Development vs Production

```dart
// Development
final devClient = AppAtOnceClient(
  apiKey: const String.fromEnvironment('APPATONCE_API_KEY'),
  baseUrl: const String.fromEnvironment(
    'APPATONCE_URL',
    defaultValue: 'https://dev.appatonce.com',
  ),
  debug: true,
);

// Production
final prodClient = AppAtOnceClient(
  apiKey: const String.fromEnvironment('APPATONCE_API_KEY'),
  baseUrl: const String.fromEnvironment('APPATONCE_URL'),
  timeout: Duration(seconds: 60),
  retries: 5,
  debug: false,
);
```

## Type Safety

The SDK is built with strong type safety in mind:

```dart
// Define your models
class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    createdAt: DateTime.parse(json['created_at']),
    isActive: json['is_active'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'created_at': createdAt.toIso8601String(),
    'is_active': isActive,
  };
}

// Type-safe queries
final response = await client.data
  .from('users')
  .select('*')
  .where('is_active', true)
  .execute();

// Parse response with type safety
final users = (response['data'] as List)
  .map((json) => User.fromJson(json))
  .toList();

// Type-safe inserts
final newUser = await client.data.insert('users', User(
  id: 'unique-id',
  email: 'user@example.com',
  name: 'New User',
  createdAt: DateTime.now(),
  isActive: true,
).toJson());
```

## Documentation Links

For detailed guides and API references, visit our documentation:

### 📚 Core Guides
- **<a href="https://appatonce.com/docs/database" target="_blank">Database Guide</a>** - Schema management, queries, real-time subscriptions
- **<a href="https://appatonce.com/docs/ai-ml" target="_blank">AI Integration</a>** - Text generation, image creation, embeddings
- **<a href="https://appatonce.com/docs/real-time" target="_blank">Real-time Guide</a>** - WebSocket connections, pub/sub, presence
- **<a href="https://appatonce.com/docs/storage" target="_blank">Storage Guide</a>** - File uploads, image processing, CDN
- **<a href="https://appatonce.com/docs/authentication" target="_blank">Authentication</a>** - User management, OAuth, API keys

### 🔧 Advanced Topics
- **<a href="https://appatonce.com/docs/workflows" target="_blank">Workflow Engine</a>** - Automation, triggers, visual workflow builder
- **<a href="https://appatonce.com/docs/communications" target="_blank">Email & Push</a>** - Templates, campaigns, notifications
- **<a href="https://appatonce.com/docs/schema" target="_blank">Schema Management</a>** - Migrations, indexes, analysis
- **<a href="https://appatonce.com/docs/search" target="_blank">Search & Analytics</a>** - Text search, semantic search, metrics

### 📖 Examples & Tutorials
- **<a href="https://appatonce.com/docs/tutorial" target="_blank">Getting Started Tutorial</a>** - Build your first app
- **<a href="https://appatonce.com/docs/examples" target="_blank">Example Projects</a>** - Complete applications
- **<a href="https://appatonce.com/docs/best-practices" target="_blank">Best Practices</a>** - Production recommendations

## Platform SDKs

- **<a href="https://github.com/app-at-once/node-sdk" target="_blank">Node.js SDK</a>** - ✅ Available (server-side applications)
- **Flutter SDK** - ✅ This repository (cross-platform mobile & web)
- **Python SDK** - 📋 Planned
- **Swift SDK** - 📋 Planned
- **Ruby SDK** - 📋 Planned
- **PHP SDK** - 📋 Planned

## Examples & Resources

### 📂 [Examples Directory](./example/)

The `example/` folder contains comprehensive code samples demonstrating all SDK features:

#### Core SDK Examples
- **[`basic_usage.dart`](./example/basic_usage.dart)** - Basic SDK initialization and simple operations
- **[`complete_sdk_example.dart`](./example/complete_sdk_example.dart)** - Comprehensive example showcasing all major SDK features
- **[`query_builder.dart`](./example/query_builder.dart)** - Advanced query building capabilities for database operations
- **[`advanced_features.dart`](./example/advanced_features.dart)** - Latest v2.0 features: payment processing, image/PDF processing, OCR, workflows

#### Authentication & Authorization Examples
- **[`auth.dart`](./example/auth.dart)** - Complete authentication flow: signup, signin, password reset, 2FA
- **[`oauth.dart`](./example/oauth.dart)** - OAuth integration with multiple providers (Google, GitHub, Facebook)

#### Communication Services Examples
- **[`email.dart`](./example/email.dart)** - Email service: transactional emails, templates, campaigns, analytics
- **[`push_notifications.dart`](./example/push_notifications.dart)** - Push notifications: device registration, topics, campaigns

#### Document Processing Examples
- **[`pdf.dart`](./example/pdf.dart)** - PDF generation, manipulation, watermarks, text extraction
- **[`ocr.dart`](./example/ocr.dart)** - OCR: text extraction, table detection, receipt parsing, ID cards

#### AI Service Examples (in `ai/` subfolder)
- **Text-Based AI (01-08)** - Text generation, content creation, language processing, code assistance, etc.
- **Unified AI (10-13)** - Complete AI example, image generation, audio generation, video generation

See [AI Examples README](./example/ai/README.md) for detailed AI feature documentation

#### Quick Start
```bash
# Clone and install
git clone https://github.com/app-at-once/flutter-sdk.git
cd flutter-sdk/example

# Set your API key (get it from https://appatonce.com/login)
export APPATONCE_API_KEY=your_api_key_here

# Install dependencies
flutter pub get

# Run any example
flutter run -t lib/basic_usage.dart
```

### 📚 Online Resources

For comprehensive guides and tutorials:

- **<a href="https://appatonce.com/docs" target="_blank">Complete Documentation</a>** - Detailed guides and API reference
- **<a href="https://appatonce.com/docs/tutorial" target="_blank">Tutorial Series</a>** - Step-by-step learning path
- **<a href="https://appatonce.com/docs/examples" target="_blank">Example Projects</a>** - Real-world applications

### Featured Project Examples
- **Blog Platform** - Full-stack blog with AI content generation
- **E-commerce System** - Product catalog with real-time inventory
- **Chat Application** - Real-time messaging with presence
- **Task Manager** - Collaborative workspace with workflows
- **Image Gallery** - AI-powered tagging and search

## Support & Community

### Get Help
- **📖 <a href="https://appatonce.com/docs" target="_blank">Documentation</a>** - Complete guides and API reference
- **💬 <a href="https://discord.gg/appatonce" target="_blank">Discord Community</a>** - Chat with other developers
- **📧 <a href="mailto:support@appatonce.com">Email Support</a>** - Direct technical support
- **🐛 <a href="https://github.com/app-at-once/flutter-sdk/issues" target="_blank">GitHub Issues</a>** - Bug reports and feature requests

### Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Ready to build something amazing?** 🚀

<a href="https://appatonce.com" target="_blank">Sign up at appatonce.com</a> and get your API key in minutes.

*Built with ❤️ by the AppAtOnce team*

