# Budget Builder Quest

An offline Android budgeting game from WGRALGO / The Wealth Gap Resolution Algorithm™ Inc.

Built with Capacitor wrapping a static HTML/JS web app.

## Debug APK

Every push triggers the `Android Debug Build` GitHub Actions workflow which
produces a debug APK as a downloadable artifact.

## Local build

```bash
npm install
npx cap sync android
cd android
./gradlew assembleDebug
```

APK lands at `android/app/build/outputs/apk/debug/app-debug.apk`.

## Regenerate icon + splash

Source assets live in `assets/icon.png` and `assets/splash.png`. After changing
them:

```bash
npx capacitor-assets generate --android \
  --iconBackgroundColor "#000000" \
  --iconBackgroundColorDark "#000000" \
  --splashBackgroundColor "#000000" \
  --splashBackgroundColorDark "#000000"
```

The launcher background is forced to `#000000` in
`android/app/src/main/res/values/ic_launcher_background.xml` so the adaptive
icon shows the logo on black — no white square.
