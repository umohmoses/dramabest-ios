# Dramabest iOS launch

The app is built on **Codemagic** (a cloud Mac) and sent straight to **App Store Connect → TestFlight**.
Bundle ID: `com.dramabest.story` · App name: **Dramabest** · Version: same as `pubspec.yaml`.

## Already done in the project
- Bundle ID changed from the template's `com.incodes.storybox` to `com.dramabest.story`; the template seller's Apple team removed.
- App name on the home screen: Dramabest.
- Push notifications set for App Store builds; background push enabled.
- Plain-English permission texts (Apple rejects vague ones); "no special encryption" declared so uploads skip the export question.
- `codemagic.yaml` builds, signs and uploads to TestFlight with the next free build number.
- `.gitignore` keeps the Android signing key and build files out of git.

## Your steps (one time)

### 1. Apple Developer (developer.apple.com → Certificates, IDs & Profiles)
1. **Identifiers → com.dramabest.story** (created with the app record): tick **Push Notifications**, **Sign in with Apple** and **Associated Domains**. Save.
2. **Keys → +**: name "Dramabest push", tick **Apple Push Notifications service (APNs)**, download the `.p8` file (only downloadable once). Note the **Key ID**.
3. Team ID: **G9RMQSFTQQ** (already set in the project).

### 2. App Store Connect API key (for Codemagic)
Users and Access → Integrations → App Store Connect API → **+**, name "Codemagic", access **App Manager**.
Download the `.p8` (once only), note the **Issuer ID** and **Key ID**. Type these into Codemagic only, never into chat.

### 3. Firebase (project dramabest-25b22)
1. Project settings → **Add app → iOS**, bundle ID `com.dramabest.story`, nickname Dramabest iOS.
2. Download **GoogleService-Info.plist**. (It is not a secret; you can send it to Claude to check.)
3. Project settings → Cloud Messaging → **Apple app configuration → APNs authentication key**: upload the push `.p8` from step 1.2 with its Key ID and your Team ID.
4. Authentication → Sign-in method → **Apple**: switch on.

### 4. Code on GitHub
Codemagic builds from a git repository. The app folder is not in git yet; Claude can put it in a **private** repository once you say so.

### 5. Codemagic (codemagic.io, sign in with GitHub)
1. Add the app from the repository; choose **codemagic.yaml** workflow.
2. Team settings → Integrations → **Developer Portal → Connect**: name it exactly **Dramabest ASC**, paste the Issuer ID, Key ID and upload the API `.p8` from step 2.
3. App → Environment variables, group **dramabest_ios**:
   - `GOOGLE_SERVICE_INFO_PLIST`: the plist file base64-encoded (Claude can produce this text from the file), **Secure**.
   - (`APP_STORE_APPLE_ID` 6809405695 and Team ID G9RMQSFTQQ are already in the project.)
4. Start **Dramabest iOS → TestFlight**. About 20–30 minutes later the build appears in TestFlight.

### 6. Server settings Claude changes (with your go-ahead)
- iOS links (`applinks:admin.dramabest.com`) need the server's Apple site file to name `<TeamID>.com.dramabest.story` (it still has the template's ID).
- `iosAppLink` (App Store URL) and `iosAppVersion` for the update prompt, once the app is live.

## Before submitting for review: payments
**Decision (11 Nov 2026): iOS uses the same payments as Android.** The iPhone app uses the same secure checkout as Android: the server creates the order, Stripe or Flutterwave opens in the browser, and the server credits coins/VIP after the gateway confirms. The iOS switches already match Android (Stripe and Flutterwave on, Apple purchase off), so no code change was needed.

**Review risk:** Apple's guideline 3.1.1 says digital goods (coins, VIP) bought in an iPhone app must use Apple In-App Purchase. Outside the US storefront, a review may reject a build that sends buyers to Stripe/Flutterwave. If that happens, the fallback is either to hide buying on iOS (free with ads, coins from rewards/invites, VIP with coins) or to add Apple In-App Purchase with server-side checks. Both can be done without changing Android.

## App Store listing (App Store Connect → the app)
Screenshots (6.9" and 6.5" iPhone), description, keywords, support URL, privacy policy URL, age rating, App Privacy answers (data collected: email/name for sign-in, device ID for ads, purchase history), and a **demo account** for the reviewer if sign-in is required.
