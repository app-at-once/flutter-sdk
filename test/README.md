# AppAtOnce Flutter SDK Tests

This directory contains comprehensive test suites for the AppAtOnce Flutter SDK, mirroring the testing approach used in the Node SDK.

## Test Structure

```
test/
├── README.md                     # This file
├── run_tests.sh                  # Test runner script
├── test_runner.dart              # Comprehensive test runner utility
├── comprehensive_sdk_test.dart   # Main comprehensive test suite
└── modules/                      # Module-specific tests
    ├── auth_test.dart            # Authentication module tests
    ├── logic_test.dart           # Logic module tests
    ├── data_test.dart            # Data module tests (to be created)
    ├── storage_test.dart         # Storage module tests (to be created)
    ├── ai_test.dart              # AI module tests (to be created)
    ├── schema_test.dart          # Schema module tests (to be created)
    ├── push_test.dart            # Push module tests (to be created)
    └── email_test.dart           # Email module tests (to be created)
```

## Running Tests

### Prerequisites

1. **Flutter SDK**: Make sure Flutter is installed and in your PATH
2. **Dependencies**: Run `flutter pub get` to install dependencies
3. **Environment**: Set up test environment variables (optional)

### Environment Variables

```bash
export TEST_API_KEY="your-test-api-key"
export TEST_BASE_URL="http://localhost:8080"
export VERBOSE="true"
export COVERAGE="true"
```

### Test Commands

#### Run all tests with the test runner script:
```bash
./test/run_tests.sh
```

#### Run specific test suites:
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/comprehensive_sdk_test.dart

# Run module-specific tests
flutter test test/modules/auth_test.dart
flutter test test/modules/logic_test.dart

# Run tests in watch mode
flutter test --watch
```

#### Using pubspec scripts (if supported by your Flutter version):
```bash
# Run all tests
flutter pub run test

# Run with coverage
flutter pub run test:coverage

# Run comprehensive tests
dart test/test_runner.dart
```

## Test Categories

### 1. Comprehensive SDK Tests (`comprehensive_sdk_test.dart`)

Tests the entire SDK functionality end-to-end, including:
- Client initialization and configuration
- All module functionality
- Integration between modules
- Error handling and edge cases

### 2. Module-Specific Tests (`modules/`)

Individual test suites for each SDK module:

#### Authentication Tests (`auth_test.dart`)
- Sign up / Sign in
- OAuth authentication
- Magic link authentication
- Password management
- Profile management
- Session management
- Email verification

#### Logic Tests (`logic_test.dart`)
- Function publishing and management
- Function execution (sync/async)
- Version management
- A/B testing
- Analytics and monitoring
- Templates and discovery
- Deployment management
- Webhooks
- Rate limiting

#### Data Tests (`data_test.dart`)
- CRUD operations
- Query building
- Filtering and sorting
- Pagination
- Batch operations
- Real-time subscriptions

#### Storage Tests (`storage_test.dart`)
- File upload/download
- File management
- Bucket operations
- Metadata handling
- Access control

#### AI Tests (`ai_test.dart`)
- Text generation
- Image generation
- Embeddings
- Model management
- Custom prompts

#### Schema Tests (`schema_test.dart`)
- Table creation/modification
- Column management
- Index management
- Migrations
- Validation

#### Push Tests (`push_test.dart`)
- Notification sending
- Device management
- Template management
- Campaign management
- Analytics

#### Email Tests (`email_test.dart`)
- Email sending
- Template management
- Contact management
- Campaign management
- Analytics

## Test Utilities

### TestRunner (`test_runner.dart`)

A comprehensive test runner utility that provides:
- Test execution and timing
- Result tracking and reporting
- Test grouping and organization
- JSON output for CI/CD integration
- Error handling and reporting

### Mock Setup

Tests use Mockito for mocking HTTP calls and dependencies:
- Mock HTTP client for API calls
- Mock session manager for authentication
- Mock secure storage for persistence

## Test Configuration

### TestConfig Class

Configures test execution:
```dart
final config = TestConfig(
  apiKey: 'test-api-key',
  baseUrl: 'http://localhost:8080',
  verbose: true,
  timeout: Duration(seconds: 30),
);
```

### Environment-based Configuration

```dart
final config = TestConfig.fromEnvironment();
```

## Coverage Reports

Generate test coverage reports:

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

## Continuous Integration

The test suite is designed to work in CI/CD environments:

### GitHub Actions Example:
```yaml
- name: Run Flutter Tests
  run: |
    flutter pub get
    flutter test --coverage
    
- name: Upload Coverage
  uses: codecov/codecov-action@v1
  with:
    file: coverage/lcov.info
```

### Test Output

The test runner provides detailed output:
- ✅ Passed tests with timing
- ❌ Failed tests with error details
- 📊 Test summary and success rate
- 📋 Module-specific results
- 🎯 Coverage information

## Best Practices

1. **Mock External Dependencies**: Use Mockito to mock HTTP calls and external services
2. **Test Edge Cases**: Include tests for error conditions and edge cases
3. **Keep Tests Fast**: Mock heavy operations and external calls
4. **Organize by Module**: Group tests by SDK module for maintainability
5. **Use Descriptive Names**: Make test names clear and descriptive
6. **Add Setup/Teardown**: Properly initialize and clean up test resources

## Adding New Tests

When adding new functionality to the SDK:

1. **Add Unit Tests**: Create tests for the specific functionality
2. **Update Comprehensive Tests**: Add integration tests to the comprehensive suite
3. **Update Mock Responses**: Add appropriate mock responses for new API calls
4. **Document Test Cases**: Add comments explaining complex test scenarios

## Troubleshooting

### Common Issues:

1. **Mock Generation**: Run `flutter packages pub run build_runner build` to generate mocks
2. **Dependencies**: Run `flutter pub get` to update dependencies
3. **Flutter Version**: Ensure Flutter version compatibility
4. **Environment Variables**: Check that test environment variables are set correctly

### Debug Mode:

Run tests with verbose output:
```bash
VERBOSE=true flutter test
```

## Node SDK Parity

These tests mirror the functionality and structure of the Node SDK tests:
- Similar test organization and naming
- Equivalent test coverage
- Matching API test scenarios
- Same error handling patterns

This ensures both SDKs provide consistent functionality and reliability across platforms.