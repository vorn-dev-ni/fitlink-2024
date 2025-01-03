#!/bin/bash

# Get the current working directory
ROOT_DIR=$(pwd)

# Check if environment argument is passed
if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev', 'staging', or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=demoleng-a6300 \
      --out="lib/utils/firebase/firebase_options_dev.dart" \
      --ios-bundle-id=com.example.demo.dev \
      --ios-out="ios/flavors/dev/GoogleService-Info.plist" \
      --android-package-name=com.example.demo.dev \
      # --android-out="$ROOT_DIR/android/app/src/dev/google-services.json"
    ;;
  staging)
    flutterfire config \
      --project=demoleng-a6300 \
      --out="lib/utils/firebase/firebase_options_staging.dart" \
      --ios-bundle-id=com.example.demo.staging \
      --ios-out="ios/flavors/staging/GoogleService-Info.plist" \
      --android-package-name=com.example.demo.staging \
      # --android-out="$ROOT_DIR/android/app/src/stg/google-services.json"
    ;;
  prod)
    flutterfire config \
      --project=demoleng-a6300 \
      --out="lib/utils/firebase/firebase_options.dart" \
      --ios-bundle-id=com.example.demo \
      --ios-out="ios/flavors/prod/GoogleService-Info.plist" \
      --android-package-name=com.example.demo \
      # --android-out="$ROOT_DIR/android/app/src/prod/google-services.json"
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev', 'staging', or 'prod'."
    exit 1
    ;;
esac
