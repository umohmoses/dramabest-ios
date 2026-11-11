# Monetisation update (version 1.0.4+4) - Dramabest 70/30 model

- First 70% of each drama free; interstitial after every 2 completed FREE episodes (never in the premium part, never for VIP); if an ad fails to load, playback continues.
- Final 30% premium: 1 completed rewarded ad unlocks the chosen episode + the next one (server decides); or coins; or VIP.
- Rewarded ads count only when completed (closing early gives nothing) - also for the Reward page coins.
- Google AdMob server-side verification: the app sends userId + custom data (episode:drama:nonce) with each rewarded ad and waits for the server to confirm.
- Settings read from retrieveSettingsForUser -> monetisation (freePercent, interstitialEveryEpisodes, rewardedAdsRequired, episodesPerReward, dailyRewardedAdLimit, vipAccess).
- Build on a PC with Flutter 3.32.6: flutter pub get, then flutter build appbundle --release / flutter build apk --release.
- VIP/coin prices may have decimals (e.g. 1.50): VIP plan, user profile and wallet models accept decimal prices (previously whole numbers only -> VIP page/profile failed to load).
- VIP: an Offer Price of 0 means no offer (was charged 0); the old price is only crossed out when there is a real discount.
- Payments: coins and VIP are bought through the server's secure checkout (lib/payment/secure_checkout/secure_checkout.dart): the server sets the price in the buyer's currency, the buyer pays on Stripe/Flutterwave's page (browser), and coins/VIP are added only after the server verified the payment. The old gateway flows (Stripe secret key in the app, Google Play/RevenueCat VIP) are no longer used by the store, the episode unlock sheet or the insufficient-coins sheet. VIP cards in the unlock sheets buy on tap.
- Country/currency: detected by the server from the IP address (DB-IP), phone region as fallback. Buyer chooses Flutterwave or card (Stripe) when both are available; each shows the exact amount it will charge (automatic conversion when a gateway cannot charge the local currency).
