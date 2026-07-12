# Google Sign-In is normally protected by Play Services consumer rules.
# Keep these classes explicit because release auth is a critical path.
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-keep class com.google.firebase.auth.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.auth.**
