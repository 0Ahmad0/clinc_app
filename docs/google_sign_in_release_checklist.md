# Google Sign-In Release Checklist

Firebase project: `clinic-su`
Android package: `com.clinic.app`
iOS production bundle ID: `com.clinic.app`
Web OAuth client ID: `815847296623-4va1cdfoomgb5i89n6fjf1fugjd2o1vm.apps.googleusercontent.com`

## Android fingerprints to register in Firebase

Register these SHA-1 and SHA-256 fingerprints under the Android app
`com.clinic.app` in Firebase project settings, then download a fresh
`google-services.json` into `android/app/google-services.json`.

### Repository debug keystore

This keystore is committed at `android/app/debug.keystore` so debug Google
Sign-In works on every developer machine.

SHA-1:
`82:5C:51:D4:00:58:24:D0:6B:BC:2C:78:45:D5:E9:8D:45:E0:04:0E`

SHA-256:
`D6:F7:A7:CD:8C:94:C5:13:B3:5B:75:3E:1F:7B:BE:70:5E:70:B7:77:87:97:A5:04:E3:AE:9B:77:43:1D:5A:FA`

### Upload/release keystore currently used locally

SHA-1:
`42:FD:0B:59:43:E9:76:F2:18:1E:0B:E5:A4:58:7B:7F:0F:1C:B1:13`

SHA-256:
`8F:3F:70:A6:BE:75:62:3E:3C:C9:9D:4E:51:88:88:32:D3:42:12:5D:40:7A:F5:DA:BC:D5:83:2D:01:04:EF:03`

### Google Play App Signing certificate

For a published APK/AAB, also register the Google Play **app signing**
certificate SHA-1 and SHA-256 from Play Console:

`Play Console > Setup > App integrity > App signing key certificate`

The upload key is not enough for app bundles distributed through Google Play.

## OAuth clients expected in google-services.json

After the fingerprints are registered, the Android client in
`google-services.json` must contain:

- One `client_type: 3` web OAuth client.
- Android OAuth clients (`client_type: 1`) for every SHA-bound certificate:
  repository debug, upload/release, and Play app signing.

## Android release signing

Do not commit `android/key.properties` or the upload keystore. For release
builds, copy `android/key.properties.example` to `android/key.properties` and
set:

- `storeFile` to the private upload keystore path.
- `storePassword`, `keyPassword`, and `keyAlias` for that keystore.

Release builds now fail fast if this file is missing or incomplete.

## iOS

The current checked-in iOS Firebase plist is still registered for
`com.example.clincAppT1`. Before shipping iOS:

1. Decide the production bundle ID. Use `com.clinic.app` unless the Apple
   Developer account already reserves another production ID.
2. Register that exact iOS app in Firebase project `clinic-su`.
3. Download the new `GoogleService-Info.plist` into `ios/Runner/GoogleService-Info.plist`.
4. Regenerate `lib/firebase_options.dart` with FlutterFire CLI.
5. Add the plist `REVERSED_CLIENT_ID` as an iOS URL scheme in
   `ios/Runner/Info.plist`.

Google Sign-In on iOS will not be production-ready while the bundle ID and
Firebase plist disagree.
