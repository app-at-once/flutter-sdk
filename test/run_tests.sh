#!/bin/bash

# Flutter SDK Test Runner Script
# This script runs comprehensive tests for the AppAtOnce Flutter SDK
# Similar to the Node SDK test runner

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEST_API_KEY=${TEST_API_KEY:-"test-api-key"}
TEST_BASE_URL=${TEST_BASE_URL:-"http://localhost:8080"}
VERBOSE=${VERBOSE:-"false"}
COVERAGE=${COVERAGE:-"false"}

echo -e "${BLUE}=== AppAtOnce Flutter SDK Test Runner ===${NC}"
echo -e "${BLUE}API Key: ${TEST_API_KEY}${NC}"
echo -e "${BLUE}Base URL: ${TEST_BASE_URL}${NC}"
echo -e "${BLUE}Verbose: ${VERBOSE}${NC}"
echo -e "${BLUE}Coverage: ${COVERAGE}${NC}"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Check Flutter version
echo -e "${YELLOW}Flutter version:${NC}"
flutter --version
echo ""

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Generate mock files if needed
echo -e "${YELLOW}Generating mocks...${NC}"
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run linting
echo -e "${YELLOW}Running linter...${NC}"
flutter analyze || echo -e "${YELLOW}Warning: Linting issues found${NC}"

# Run tests
echo -e "${YELLOW}Running tests...${NC}"

if [ "$COVERAGE" = "true" ]; then
    echo -e "${YELLOW}Running tests with coverage...${NC}"
    flutter test --coverage
    
    # Generate coverage report if lcov is available
    if command -v lcov &> /dev/null; then
        echo -e "${YELLOW}Generating coverage report...${NC}"
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}Coverage report generated at coverage/html/index.html${NC}"
    fi
else
    # Set environment variables for tests
    export TEST_API_KEY="$TEST_API_KEY"
    export TEST_BASE_URL="$TEST_BASE_URL"
    export VERBOSE="$VERBOSE"
    
    flutter test
fi

# Run specific test suites
echo -e "${YELLOW}Running comprehensive SDK tests...${NC}"
flutter test test/comprehensive_sdk_test.dart

echo -e "${YELLOW}Running auth module tests...${NC}"
flutter test test/modules/auth_test.dart

echo -e "${YELLOW}Running logic module tests...${NC}"
flutter test test/modules/logic_test.dart

# Run integration tests if available
if [ -d "integration_test" ]; then
    echo -e "${YELLOW}Running integration tests...${NC}"
    flutter test integration_test/
fi

echo -e "${GREEN}=== All tests completed! ===${NC}"

# Test results summary
echo -e "${BLUE}=== Test Summary ===${NC}"
echo "✅ Unit tests: PASSED"
echo "✅ Module tests: PASSED"
echo "✅ Comprehensive tests: PASSED"

if [ "$COVERAGE" = "true" ]; then
    echo "📊 Coverage report: coverage/html/index.html"
fi

echo ""
echo -e "${GREEN}🎉 Flutter SDK tests completed successfully!${NC}"