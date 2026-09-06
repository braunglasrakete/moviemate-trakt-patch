#!/usr/bin/env bash
# Movie Mate — trakt.tv token & sync-pagination patch
#
# Rebuilds a user-supplied Movie Mate APK with the two fixes described
# in README.md. Requires: apktool, apksigner, zipalign, keytool (all
# from the Android SDK build-tools / a JDK).
#
# Usage:
#   ./build.sh /path/to/your/moviemate.apk
#
# Output: dist/MovieMate-patched.apk (signed with a new, locally
# generated debug-style key — you must uninstall any existing install
# of Movie Mate before installing this one, since the signature will
# differ from the original).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_APK="${1:-}"

if [[ -z "$INPUT_APK" || ! -f "$INPUT_APK" ]]; then
    echo "Usage: $0 /path/to/your/moviemate.apk"
    echo "(You need to supply your own copy of the APK — this repo does not include it.)"
    exit 1
fi

for tool in apktool apksigner zipalign keytool; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: required tool '$tool' not found on PATH."
        echo "Install Android SDK build-tools and a JDK, and make sure they're on PATH."
        exit 1
    fi
done

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

echo "==> Decoding APK with apktool..."
apktool d -f -o "$WORK_DIR/decoded" "$INPUT_APK"

echo "==> Applying patches..."
for p in "$SCRIPT_DIR"/patches/*.patch; do
    echo "    $(basename "$p")"
    patch -p1 -d "$WORK_DIR/decoded" < "$p"
done

echo "==> Adding new files..."
cp -r "$SCRIPT_DIR"/new_files/* "$WORK_DIR/decoded/"

echo "==> Rebuilding APK..."
apktool b "$WORK_DIR/decoded" -o "$WORK_DIR/unsigned.apk"

echo "==> Zipaligning..."
zipalign -p -f 4 "$WORK_DIR/unsigned.apk" "$WORK_DIR/aligned.apk"

KEYSTORE="$SCRIPT_DIR/.local-signing-key.jks"
if [[ ! -f "$KEYSTORE" ]]; then
    echo "==> Generating a local signing key (first run only)..."
    keytool -genkeypair -v -keystore "$KEYSTORE" -alias moviematepatched \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -storepass moviematepatched -keypass moviematepatched \
        -dname "CN=MovieMate Patched, OU=Personal, O=Personal, L=Unknown, ST=Unknown, C=US"
fi

echo "==> Signing..."
mkdir -p "$SCRIPT_DIR/dist"
apksigner sign --ks "$KEYSTORE" --ks-key-alias moviematepatched \
    --ks-pass pass:moviematepatched --key-pass pass:moviematepatched \
    --out "$SCRIPT_DIR/dist/MovieMate-patched.apk" "$WORK_DIR/aligned.apk"

echo "==> Verifying signature..."
apksigner verify "$SCRIPT_DIR/dist/MovieMate-patched.apk"

echo ""
echo "Done! Output: dist/MovieMate-patched.apk"
echo "NOTE: this is signed with a NEW key generated just now, different from"
echo "the original app's signature. Uninstall any existing Movie Mate install"
echo "before installing this one, or Android will refuse the install."
