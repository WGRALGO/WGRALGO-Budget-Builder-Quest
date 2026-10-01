# Changelog

All notable changes to Budget Builder Quest are documented here. Versions
follow `versionName` / `versionCode` from `android/app/build.gradle`.

## v1.1.0 — 2026-10-01

**New game version and real-app look.**

### Changed
- Game rebuilt from the latest web version: choose a life, build a full
  monthly budget with realistic minimums, then live with it for 5 months of
  curveballs (29 in the bank) with checking, emergency fund, 24% credit card
  interest, fees, and a 401(k) tracked month by month.
- Money Health Score now covers your budget plan, your choices, and where you
  ended up.
- Signed with a new key. Uninstall v1.0.x before installing v1.1.0.

### Added
- Black launch screen with the big logo (no white box on Android 12+), and a
  new launcher icon that fills round, squircle, and square icon shapes.
- Solid app bar with About / How it works, Privacy, and Credits panels.
- Android back button: steps back from the budget, asks before leaving a
  quest, and asks before exiting the app.
- GitHub Actions signed release workflow and `tools/validate-release.sh`.

### Removed
- Social-media and GoFundMe bars and the "Explore other games" link from the
  new web version.
- The `INTERNET` permission that Capacitor merges in is now stripped from the
  final manifest.

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
