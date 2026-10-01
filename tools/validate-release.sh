#!/usr/bin/env bash
# Budget Builder Quest — release validation.
# Usage: ./tools/validate-release.sh [path/to/app.apk]
# Exit non-zero if any check fails.
set -u
cd "$(dirname "$0")/.."

VERSION=$(node -p "require('./package.json').version")
CODE=$(echo "$VERSION" | awk -F. '{ print $1*100 + $2*10 + $3 }')

PASS=0
FAIL=0
ok()  { echo "  PASS  $1"; PASS=$((PASS+1)); }
bad() { echo "  FAIL  $1"; FAIL=$((FAIL+1)); }

echo "== Game data =="
OUT=$(node - <<'NODE'
const fs = require("fs");
const h = fs.readFileSync("www/index.html", "utf8");
const R = (ok, msg) => console.log((ok ? "PASS " : "FAIL ") + msg);
const grab = name => {
  const m = h.match(new RegExp("const " + name + " = \\[([\\s\\S]*?)\\n    \\];"));
  return m ? eval("[" + m[1] + "]") : null;
};
const profiles = grab("PROFILES"), cats = grab("CATEGORIES"), cbs = grab("CURVEBALLS");
const total = +(h.match(/const TOTAL_QUESTIONS = (\d+);/) || [])[1];
if (!profiles || !cats || !cbs || !total) { console.log("FAIL game data not found"); process.exit(0); }
R(profiles.length === 3, profiles.length + " profiles");
R(profiles.every(p => p.income > 0 && cats.every(c => c.id in p.min && c.id in p.lastMonth)),
  "every profile has income and a minimum and last-month amount for every category");
R(profiles.every(p => Object.values(p.min).reduce((t, v) => t + v, 0) <= p.income),
  "every profile can cover its minimum bills");
R(new Set(cbs.map(c => c.id)).size === cbs.length, cbs.length + " curveballs, no duplicate ids");
R(cbs.every(c => c.title && c.text && Array.isArray(c.options) && c.options.length >= 2 &&
  c.options.every(o => o.label && o.why && typeof o.points === "number")),
  "every curveball has a title, text, and at least 2 explained choices");
for (const p of profiles) {
  const n = cbs.filter(c => !c.only || c.only.indexOf(p.id) !== -1).length;
  R(n >= total, p.id + ": " + n + " curveballs available (needs " + total + ")");
}
R(/window\.onAndroidBack = function/.test(h), "Android back button hook present");
NODE
)
while IFS= read -r line; do
  case "$line" in
    PASS*) ok "${line#PASS }" ;;
    FAIL*) bad "${line#FAIL }" ;;
  esac
done <<< "$OUT"

echo "== Version $VERSION (code $CODE) =="
GR=android/app/build.gradle
grep -q "versionName \"$VERSION\"" $GR && ok "versionName $VERSION" || bad "versionName is not $VERSION"
grep -q "versionCode $CODE" $GR && ok "versionCode $CODE" || bad "versionCode is not $CODE"
grep -q "v$VERSION" www/index.html && ok "app shows v$VERSION" || bad "app does not show v$VERSION"
grep -q "$VERSION" README.md && ok "README mentions $VERSION" || bad "README missing $VERSION"
[ -f "release-notes/v$VERSION.md" ] && ok "release-notes/v$VERSION.md present" || bad "release-notes/v$VERSION.md missing"

echo "== Build config =="
grep -q 'applicationId "com.wgra.budgetbuilder2"' $GR && ok "appId com.wgra.budgetbuilder2" || bad "appId wrong"
grep -q 'debuggable false' $GR && ok "release debuggable false" || bad "release not debuggable false"
grep -q 'minifyEnabled true' $GR && ok "minify enabled" || bad "minify not enabled"
MAN=android/app/src/main/AndroidManifest.xml
grep -q 'android.permission.INTERNET" tools:node="remove"' $MAN && ok "INTERNET permission stripped" || bad "INTERNET permission not stripped"

echo "== Logo, icon, splash =="
RES=android/app/src/main/res
[ -f "$RES/drawable-nodpi/splash_icon.jpg" ] && ok "Android 12+ splash logo present" || bad "splash_icon.jpg missing"
grep -q 'windowSplashScreenAnimatedIcon">@drawable/splash_icon' $RES/values/styles.xml && ok "system splash uses the logo" || bad "system splash not set to the logo"
grep -q 'windowSplashScreenBackground">@android:color/black' $RES/values/styles.xml && ok "system splash background is black" || bad "system splash background not black"
grep -q '#000000' $RES/values/ic_launcher_background.xml && ok "icon background is black" || bad "icon background not black"
[ -f www/logo.jpg ] && ok "in-app logo present" || bad "in-app logo missing"

echo "== App privacy =="
IDX=www/index.html
grep -qi 'Content-Security-Policy' $IDX && ok "CSP present" || bad "CSP missing"
grep -Eqi 'href="(https?:)?//|href="/|src="https?://|@import' $IDX && bad "external link or resource in app" || ok "no external links or resources"
grep -Eqi 'gofundme\.com|facebook\.com|instagram\.com|tiktok\.com|youtube\.com' $IDX && bad "donation/social link in app" || ok "no donation or social links"
grep -Eqi 'google-analytics|googletagmanager|gtag\(|firebase|admob' $IDX && bad "analytics/ads reference" || ok "no analytics or ads"
grep -Eq 'localStorage|sessionStorage|indexedDB|document\.cookie' $IDX && bad "app stores data on device" || ok "no on-device storage"

echo "== License =="
grep -q '"license": "GPL-3.0-only"' package.json && ok "package.json license GPL-3.0-only" || bad "package.json license not GPL-3.0-only"
grep -q 'GNU GENERAL PUBLIC LICENSE' LICENSE && ok "LICENSE is GPLv3" || bad "LICENSE is not GPLv3"

if [ "${1:-}" != "" ] && [ -f "${1:-}" ]; then
  APK="$1"
  echo "== APK: $APK =="
  SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
  BT=$(ls -d "$SDK"/build-tools/* 2>/dev/null | sort -V | tail -1)
  if [ -x "$BT/aapt2" ]; then
    DUMP=$("$BT/aapt2" dump badging "$APK" 2>/dev/null)
    echo "$DUMP" | grep -q "versionName='$VERSION'" && ok "APK versionName $VERSION" || bad "APK versionName wrong"
    echo "$DUMP" | grep -q "versionCode='$CODE'" && ok "APK versionCode $CODE" || bad "APK versionCode wrong"
    echo "$DUMP" | grep -q "package: name='com.wgra.budgetbuilder2'" && ok "APK package id" || bad "APK package id wrong"
    echo "$DUMP" | grep -q "uses-permission: name='android.permission.INTERNET'" && bad "APK declares INTERNET" || ok "APK has no INTERNET permission"
  else
    bad "aapt2 not found"
  fi
  if [ -x "$BT/apksigner" ]; then
    CERT=$("$BT/apksigner" verify --print-certs "$APK" 2>/dev/null)
    echo "$CERT" | grep -qi "CN=Android Debug" && bad "APK signed with debug cert" || ok "APK not signed with debug cert"
    "$BT/apksigner" verify "$APK" >/dev/null 2>&1 && ok "APK signature verifies" || bad "APK signature invalid/unsigned"
  else
    bad "apksigner not found"
  fi
else
  echo "== APK checks skipped (no APK path given) =="
fi

echo
echo "RESULT: $PASS passed, $FAIL failed"
[ $FAIL -eq 0 ]
