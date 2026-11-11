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

## Your steps (one time) — status 11 Nov 2026

### 1. Apple Developer (developer.apple.com → Certificates, IDs & Profiles) 
1. **Identifiers → com.dramabest.story**: make sure **Push Notifications**, **Sign in with Apple** and **Associated Domains** are all ticked. Save. *(Associated Domains must be on, or signing fails.)*
2. Push key: **done** (Dramabest Notification, Key ID FJF237872L, uploaded to Firebase).
3. Team ID: **G9RMQSFTQQ** (in the project).

### 2. App Store Connect API key for Codemagic: **done** (Codemagic key "dramabest").

### 3. Firebase (dramabest-25b22): iOS app **done**, GoogleService-Info.plist is in the project, APNs key **done**.
Still check: Authentication → Sign-in method → **Apple** switched on.

### 4. Code on GitHub: **done** — private repo umohmoses/dramabest-ios.

### 5. Codemagic (codemagic.io)
1. **Applications → Add application** → GitHub → `dramabest-ios` → project type **Flutter App (via codemagic.yaml)**.
2. **Team settings → Code signing identities**:
   - **iOS certificates → Generate certificate** (type Apple Distribution, using key "dramabest"). If you already have a distribution certificate from the Dilon apps you can use *Fetch certificate* instead, but it needs its private key (.p12); generating a new one is simpler (Apple allows several).
   - **iOS provisioning profiles → Fetch profiles** → pick the **App Store** profile for `com.dramabest.story`. If none is listed, create it at developer.apple.com → Profiles → + → **App Store Connect** → App ID com.dramabest.story → the distribution certificate, then fetch again.
3. Open the app → **Start new build** → workflow **Dramabest iOS -> TestFlight**. About 20–30 minutes later the build appears in App Store Connect → TestFlight.

### 6. Server settings Claude changes (with your go-ahead)
- iOS links (`applinks:admin.dramabest.com`) need the server's Apple site file to name `<TeamID>.com.dramabest.story` (it still has the template's ID).
- `iosAppLink` (App Store URL) and `iosAppVersion` for the update prompt, once the app is live.

## Before submitting for review: payments
**Decision (11 Nov 2026): iOS uses the same payments as Android.** The iPhone app uses the same secure checkout as Android: the server creates the order, Stripe or Flutterwave opens in the browser, and the server credits coins/VIP after the gateway confirms. The iOS switches already match Android (Stripe and Flutterwave on, Apple purchase off), so no code change was needed.

**Review risk:** Apple's guideline 3.1.1 says digital goods (coins, VIP) bought in an iPhone app must use Apple In-App Purchase. Outside the US storefront, a review may reject a build that sends buyers to Stripe/Flutterwave. If that happens, the fallback is either to hide buying on iOS (free with ads, coins from rewards/invites, VIP with coins) or to add Apple In-App Purchase with server-side checks. Both can be done without changing Android.

## App Store listing (App Store Connect → the app)
Screenshots (6.9" and 6.5" iPhone), description, keywords, support URL, privacy policy URL, age rating, App Privacy answers (data collected: email/name for sign-in, device ID for ads, purchase history), and a **demo account** for the reviewer if sign-in is required.
