# Scripts Directory

This directory contains utility scripts for the Flutter SDK development and deployment process.

## Scripts

### patch-urls-for-public.sh

Patches hardcoded URLs in the SDK from localhost to production API endpoints when publishing to the public repository.

**Usage:**
```bash
./scripts/patch-urls-for-public.sh
```

This script is automatically run by the GitHub Actions workflow when publishing to the public repository.

## Adding New Scripts

When adding new scripts:
1. Make them executable: `chmod +x script-name.sh`
2. Add proper error handling
3. Include a header comment explaining the script's purpose
4. Update this README with the new script's documentation