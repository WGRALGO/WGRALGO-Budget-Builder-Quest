# Changelog

All notable changes to Budget Builder Quest are documented here. Versions
follow `versionName` / `versionCode` from `android/app/build.gradle`.

## v1.0.1 — 2026-05-23

**Standalone-APK overhaul.**

### Removed
- Social-media icon bar at the top of the app (Facebook, Instagram, TikTok, X,
  YouTube, LinkedIn).
- Top GoFundMe donation bar.
- External "Explore other games" outbound link from the results screen.
- The `android.permission.INTERNET` declaration — the app is now fully offline.

### Added
- Proper Android-app landing screen with centered logo, title, tagline, and
  primary **Start Quest** / secondary **How It Works** actions.
- Modal "How It Works" overlay explaining the three steps.
- Results screen now shows a prominent **Money Health Score**, plus Income,
  Expenses, planned Savings, and Emergency-fund impact as stat cards.
- Per-curveball running score so players see live impact of each choice.
- `data_extraction_rules.xml` to disable cloud backup and device transfer of
  any app data.
- GPLv3 `LICENSE`, `PRIVACY.md`, `CONTRIBUTORS.md`, `CHANGELOG.md`.

### Changed
- Rewrote `www/index.html` with a real HTML5 document (DOCTYPE, charset,
  `viewport-fit=cover`, Content-Security-Policy, theme color).
- Card-based, touch-first layout sized for phones and tablets. Inputs are at
  least 44–52 px tall. Red is reserved for losses/warnings, green for positive
  outcomes.
- `android:allowBackup="false"`, `usesCleartextTraffic="false"`.
- `package.json`: license `GPL-3.0-only`, real description, real keywords,
  build scripts.

### Kept
- `applicationId` `com.wgra.budgetbuilder2` (preserves upgrade path from
  v1.0.0).
- Signing certificate `CN=WGRALGO`.
- Adaptive icon background `#000000` (no white square).

## v1.0.0 — 2026-05-23

- First official public release.
- Signed release APK (`CN=WGRALGO`).
- Capacitor 6 wrapper.
- Logo-based adaptive icon and splash on solid black.
