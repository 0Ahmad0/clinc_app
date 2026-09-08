# Verified Google Play configuration — 2026-09-09

Current Android package: `com.clinic.user` in Firebase project `clinic-su`.
Firebase Android app: `1:815847296623:android:e32a098b29d7c8dbfa879a`.

Google Play Console key management was checked directly. The current classical
SHA-1 (`a8fedd8fac7fb52b39c33993116e0b0f5e68cf19`) and post-quantum SHA-1
(`fea3c4281850092b440701343bcb93a86c4c4c75`) were already registered.
The previous app signing certificate was missing from Firebase:

- SHA-1: `DB:4B:6A:9C:6F:05:33:49:70:FC:E1:EB:12:C2:56:8C:61:53:6C:6C`
- SHA-256: `12:05:A9:61:0B:95:BB:E4:01:1F:8D:A7:61:69:82:F5:12:DC:EE:07:85:2C:2E:B3:BE:85:F0:6D:A8:B4:BF:7E`

Both fingerprints were registered. A freshly downloaded Firebase configuration
confirmed Android OAuth client
`815847296623-9o58n8a81mu4cn0qehlfj7u6qu8ldchf.apps.googleusercontent.com`
for that exact package and SHA-1. That client was added to the local config.
The existing explicit serverClientId was preserved; changing the Web client
would also require checking backend token audience validation.

Validation still required: sign in on a physical device using the Google Play
installed build. The connected emulator has a locally installed app, so it
does not validate Play signing. No new release was uploaded during this fix.

The checklist below is historical and refers to the former `com.clinic.app`
package; do not use it as the current package configuration.

---

# Google Sign-In Release Checklist

Firebase project: `clinic-su`
Android package: `com.clinic.app`
iOS production bundle ID: `com.clinic.app`
Web OAuth client ID: `815847296623-4va1cdfoomgb5i89n6fjf1fugjd2o1vm.apps.googleusercontent.com`

## Android fingerprints to register in Firebase

Register these SHA-1 and SHA-256 fingerprints under the Android app
`com.clinic.app` in Firebase project settings, then download a fresh
`google-services.json` into `android/app/google-services.json`.

### Local debug keystore

Debug builds use the standard Android debug keystore at
`~/.android/debug.keystore`. Register the SHA-1 and SHA-256 from
`./gradlew signingReport` for each developer machine that needs Google Sign-In.

The current local machine fingerprints are:

SHA-1:
`80:4D:BC:17:C1:9F:FD:55:6D:1D:97:52:42:CE:7C:AA:F3:4C:5A:39`

SHA-256:
`8A:05:C4:42:A6:1E:3E:97:45:15:8E:27:B1:42:9A:DF:0D:94:CC:71:48:F9:E2:95:5C:E9:58:F4:D1:BF:BF:53`

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

Current downloaded Firebase config state:

- Web OAuth client (`client_type: 3`):
  `815847296623-4va1cdfoomgb5i89n6fjf1fugjd2o1vm.apps.googleusercontent.com`
- Debug Android OAuth client (`client_type: 1`):
  `815847296623-lt1j9ds0hd9ln495b0f8i6gcu4309ce8.apps.googleusercontent.com`
  for SHA-1 `804dbc17c19ffd556d1d975242ce7caaf34c5a39`
- Missing release Android OAuth client for SHA-1
  `42fd0b5943e976f2181e0be5a4587b7f0f1cb113`

Before release, Firebase/Google Cloud must emit an Android OAuth client
(`client_type: 1`) for the upload/release certificate SHA-1 above. If Firebase
Project settings shows the SHA but the downloaded config still omits the
Android OAuth client, create or repair it in:

`Google Cloud Console > APIs & Services > Credentials > Create credentials > OAuth client ID > Android`

Use:

- Package name: `com.clinic.app`
- SHA-1 certificate fingerprint:
  `42:FD:0B:59:43:E9:76:F2:18:1E:0B:E5:A4:58:7B:7F:0F:1C:B1:13`

Then download a fresh `android/app/google-services.json`, rebuild release, and
verify the release APK again. For an app bundle distributed through Google Play,
also create/verify an Android OAuth client for the Play app-signing SHA-1.

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
