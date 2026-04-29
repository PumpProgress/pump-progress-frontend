-keep class com.google.mediapipe.** { *; }
-dontwarn com.google.mediapipe.**

-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }

-keep class io.flutter.plugins.** { *; }
