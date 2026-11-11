# R8 rules for the Dramabest release build (code shrinking + obfuscation).
# Most plugins ship their own rules; these cover the known gaps.

# Stripe (kept from the original file)
-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.paymentsheet.** { *; }
# Push provisioning is an optional Stripe module the SDK references.
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.**

# Flutter references Play Core (deferred components) that this app doesn't include.
-dontwarn com.google.android.play.core.**

# Keep line numbers so Play crash reports stay readable (deobfuscated with mapping.txt).
-keepattributes SourceFile,LineNumberTable,Signature,*Annotation*,InnerClasses,EnclosingMethod
-renamesourcefileattribute SourceFile

# WebView JavaScript bridges (Razorpay, Flutterwave, Cashfree, PayPal checkout pages).
-keepattributes JavascriptInterface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
-dontwarn proguard.annotation.**

# Cashfree
-keep class com.cashfree.** { *; }
-dontwarn com.cashfree.**

# Local notifications stores scheduled notifications with Gson.
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Branch deep links
-keep class io.branch.** { *; }
-dontwarn io.branch.**
-dontwarn com.google.firebase.appindexing.**
