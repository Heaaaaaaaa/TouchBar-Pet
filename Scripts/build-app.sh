#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="TouchBarPet"
APP_DISPLAY_NAME="TouchBar Pet"
BUILD_DIR="$ROOT_DIR/Build"
APP_BUNDLE="$BUILD_DIR/$APP_DISPLAY_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
INFO_PLIST="$ROOT_DIR/Resources/Info.plist"

SDK_PATH="${SDKROOT:-}"

if [[ -z "$SDK_PATH" ]]; then
  if [[ -d "/Applications/Xcode.app" ]]; then
    SDK_PATH="$(xcrun --sdk macosx --show-sdk-path)"
  elif [[ -d "/Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk" ]]; then
    SDK_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX15.4.sdk"
  else
    SDK_PATH="$(xcrun --sdk macosx --show-sdk-path)"
  fi
fi

mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
cp "$INFO_PLIST" "$CONTENTS_DIR/Info.plist"
cp "$ROOT_DIR/Resources/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
rm -rf "$RESOURCES_DIR/PixelArt"
cp -R "$ROOT_DIR/Sources/TouchBarPet/Resources/PixelArt" "$RESOURCES_DIR/PixelArt"
rm -rf "$RESOURCES_DIR/Icons"
cp -R "$ROOT_DIR/Sources/TouchBarPet/Resources/Icons" "$RESOURCES_DIR/Icons"

clang \
  -fobjc-arc \
  -isysroot "$SDK_PATH" \
  -I "$ROOT_DIR/Sources/TouchBarPrivate/include" \
  -c "$ROOT_DIR/Sources/TouchBarPrivate/TouchBarPrivate.m" \
  -o "$BUILD_DIR/TouchBarPrivate.o"

env CLANG_MODULE_CACHE_PATH="${CLANG_MODULE_CACHE_PATH:-/tmp/touchbarpet-clang-cache}" \
  swiftc \
  -sdk "$SDK_PATH" \
  -framework AppKit \
  -I "$ROOT_DIR/Sources/TouchBarPrivate/include" \
  "$BUILD_DIR/TouchBarPrivate.o" \
  "$ROOT_DIR"/Sources/TouchBarPet/*.swift \
  -o "$MACOS_DIR/$APP_NAME"

chmod +x "$MACOS_DIR/$APP_NAME"
touch "$APP_BUNDLE"

echo "Built $APP_BUNDLE"
