#!/bin/bash

# Application name
APP="new_mac_desktop"

# Application path
APP_PATH="./build/macos/Build/Products/Release/$APP.app"

# Unsigned package path
PKG_PATH_UNSIGNED="./build/macos/Build/Products/Release/$APP-unsigned.pkg"

# Signed package path
PKG_PATH="./build/macos/Build/Products/Release/$APP.pkg"

# Code signing certificates
DEV_CERT="3rd Party Mac Developer Application: NEVERCODE LTD (X8NNQ9CYL2)"
INSTALLER_CERT="3rd Party Mac Developer Installer: NEVERCODE LTD (X8NNQ9CYL2)"

FRAMEWORKS_PATH="$APP_PATH/Contents/Frameworks"

cp macos/Runner/Release.entitlements entitlements.plist

for file in $(ls $FRAMEWORKS_PATH)
do
  codesign -s "$DEV_CERT" -f --entitlements entitlements.plist $FRAMEWORKS_PATH/$file
done;

codesign -s "$DEV_CERT" -f --entitlements entitlements.plist "$APP_PATH/Contents/MacOS/$APP"
codesign -s "$DEV_CERT" -f --entitlements entitlements.plist "$APP_PATH"

xcrun productbuild --component $APP_PATH /Applications/ $PKG_PATH_UNSIGNED
xcrun productsign --sign $INSTALLER_CERT $PKG_PATH_UNSIGNED $PKG_PATH
xcrun altool --upload-app --file $PKG_PATH --type osx --username arnold@nevercode.io --password fbqd-otii-whmv-irlx