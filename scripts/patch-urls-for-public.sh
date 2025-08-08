#!/bin/bash

# This script patches the hardcoded URLs in the SDK from localhost to api.appatonce.com
# Used when publishing to the public repository

echo "🔧 Patching URLs for public repository..."

# Function to patch files with proper handling for macOS and Linux
patch_file() {
    local file=$1
    if [ -f "$file" ]; then
        echo "  Patching $file..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' 's|http://localhost:8091/api/v1|https://api.appatonce.com/api/v1|g' "$file"
        else
            # Linux
            sed -i 's|http://localhost:8091/api/v1|https://api.appatonce.com/api/v1|g' "$file"
        fi
    fi
}

# Patch Dart source files
find lib -name "*.dart" -type f | while read -r file; do
    patch_file "$file"
done

# Patch example files
if [ -d "example" ]; then
    find example -name "*.dart" -type f | while read -r file; do
        patch_file "$file"
    done
fi

# Patch test files
if [ -d "test" ]; then
    find test -name "*.dart" -type f | while read -r file; do
        patch_file "$file"
    done
fi

# Patch configuration files
patch_file "lib/src/constants.dart"
patch_file "lib/src/config/api_config.dart"
patch_file "lib/src/client/appatonce_client.dart"

# Patch README.md to ensure all localhost references are updated
patch_file "README.md"

# Patch pubspec.yaml homepage/repository if needed
if [ -f "pubspec.yaml" ]; then
    echo "  Updating pubspec.yaml repository URL..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' 's|https://github.com/app-at-once/flutter-sdk-dev|https://github.com/app-at-once/flutter-sdk|g' pubspec.yaml
    else
        # Linux
        sed -i 's|https://github.com/app-at-once/flutter-sdk-dev|https://github.com/app-at-once/flutter-sdk|g' pubspec.yaml
    fi
fi

echo "✅ URL patching complete!"