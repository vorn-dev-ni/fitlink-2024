# Fitlink 2024

## Features

- Firebase Integration: Seamless authentication and database storage.
- Native Splash Screen: A custom splash screen for your app's launch.
- App Configuration: Using .env for environment variables.
- AI Integration: Integration with Google Generative AI for additional features.
- File Picker: Easy selection of files from the device.
- Riverpod for State Management: A robust state management solution.
- Image and File Management: Integration of image picking and file handling.
- Firebase Analytics & Crashlytics: Monitoring user activity and app crashes.

## Libraries

### Main Libraries

- firebase_core: Firebase core package to initialize Firebase.
- flutter_launcher_icons: Custom app icons for your application.
- firebase_auth: Firebase authentication for user login.
- cloud_firestore: Cloud Firestore for storing user data.
- flutter_svg: SVG support for app assets.
- flutter_dotenv: Environment variable management.
- google_generative_ai: Integration with Google AI for advanced features.
- flutter_native_splash: Custom splash screen on app startup.
- flutter_riverpod: A modern state management solution for Flutter.
- dio: Powerful HTTP client for making API calls.
- image_picker: Allows users to pick images from their gallery or camera.
- firebase_remote_config: Fetch remote configurations.
- firebase_analytics: Analytics tracking.
- firebase_crashlytics: Crash reporting.
- connectivity_plus: Network connectivity checks.
- package_info_plus: Get app version details.
- device_info_plus: Get deivce info
### Development Libraries

- flutter_test: Testing package for Flutter apps.
- riverpod_generator: Code generation for Riverpod.
- build_runner: Code generation tool.
- custom_lint: Linter for custom linting rules.
- riverpod_lint: Lint rules for Riverpod usage.

## Environment

- Flutter SDK version: 3.5.4
- Dart SDK version: Compatible with Flutter SDK version 3.5.4

## Setup

### Environment Files

This project uses environment variables defined in .env files to manage different configurations for different flavors (e.g., prod, staging). 

1. Create `.env` files for each flavor:

   - For Staging: Create .env.staging file
   - For Production: Create .env.prod file

   Example of variables in .env files:
      API_URL=https://staging.api.example.com  # For staging
   API_URL=https://api.example.com          # For production
   

2. Add the `.env` files to your project:
   - Place .env.staging and .env.prod in the root of your project.

3. Load environment variables based on the active flavor. 
   The .env file will be automatically loaded depending on the selected flavor.

### How to Use Flavors

To use different environment configurations for different flavors (staging, prod), follow the steps below:

1. Define the flavors in `flutter` configuration:
   - Open your ios/Runner.xcodeproj or android/app/build.gradle and ensure the flavors (prod, staging) are defined.

2. Use the flavor when building the app:

   - You can run the app with a specific flavor by passing it in the terminal using the --flavor flag:
   
          flutter run --flavor prod
     flutter run --flavor staging
     

### Custom Script to Run with Flavors

You can use a custom script (flutter.sh) to simplify running the app with flavors.

1. Create `flutter.sh` script: (Make sure the script is executable)
   
   Create a flutter.sh file in the root of your project:
      #!/bin/bash
   if [ "$1" == "--flavor" ]; then
     if [ "$2" == "prod" ]; then
       flutter run --flavor prod
     elif [ "$2" == "staging" ]; then
       flutter run --flavor staging
     else
       echo "Invalid flavor. Use 'prod' or 'staging'."
     fi
   else
     echo "Usage: flutter.sh --flavor <flavor_name>"
   fi
   

2. Make the script executable:

      chmod +x flutter.sh

Siv Sovanpanhavorn, [12/10/24 9:20 AM]
3. Run the script:
   
   To run the app with the desired flavor, use the following command:

      ./flutter.sh --flavor prod
   

   or

      ./flutter.sh --flavor staging
   

This custom script will handle the correct flavor setup based on the arguments passed.

## Running the App

1. Clone the repository:

2. Install dependencies:

      flutter pub get
   

3. Run the app with the desired flavor (either prod or staging):

      ./flutter.sh --flavor prod
   

   or

      ./flutter.sh --flavor staging
   

## Assets

- Images and icons are stored in the assets/ directory.
- Lottie animations are stored in assets/lotties/.



---
