# Keep Firebase Auth classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.internal.** { *; }
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.firebase.auth.** { *; }
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**
-keepclasseswithmembers class com.google.firebase.FirebaseException { *; }

# Keep serialized JSON models (if using Firestore)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

