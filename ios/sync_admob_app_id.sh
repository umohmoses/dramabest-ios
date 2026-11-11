#!/bin/sh
# Run on a Mac before building for iOS. Copies the iOS AdMob App ID from the admin dashboard
# (Monetisation -> Mobile app ads -> iOS App ID) into ios/Runner/Info.plist.
set -e
cd "$(dirname "$0")/.."
KEY=$(sed -n 's/.*SECRET_KEY *= *"\([^"]*\)".*/\1/p' lib/utils/api.dart)
ID=$(curl -fsS -H "key: $KEY" https://admin.dramabest.com/api/client/setting/retrieveSettingsForUser | plutil -extract setting.ios.google.appId raw -o - -)
case "$ID" in
  ca-app-pub-*~*) /usr/libexec/PlistBuddy -c "Set :GADApplicationIdentifier $ID" ios/Runner/Info.plist; echo "iOS AdMob App ID updated" ;;
  *) echo "No iOS AdMob App ID in the admin dashboard" >&2; exit 1 ;;
esac
