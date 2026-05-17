# Flutter Proguard Rules

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Android support classes
-dontwarn androidx.**
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep your app classes
-keep class com.example.progress_tracker.** { *; }

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
