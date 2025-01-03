#!/bin/bash

# Check if an environment argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 [dev|staging|production]"
    exit 1
fi

# Set target and flavor based on the provided argument
case "$1" in
    dev)
        FLAVOR="dev"
        TARGET="lib/main_dev.dart"
        ;;
    staging)
        FLAVOR="staging"
        TARGET="lib/main_staging.dart"
        ;;
    prod)
        FLAVOR="prod"
        TARGET="lib/main.dart"
        ;;
    *)
        echo "Invalid environment. Choose from [dev|staging|prod]."
        exit 1
        ;;
esac



# Run flutter with the selected environment
echo "Running Flutter for $FLAVOR environment..."
flutter run --flavor "$FLAVOR" --target "$TARGET"
