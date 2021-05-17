#!/bin/bash

pod trunk push DriveKitDriverDataUI.podspec --synchronous || exit 1
pod trunk push DriveKitDriverAchievementUI.podspec --allow-warnings --synchronous || exit 1
pod trunk push DriveKitVehicleUI.podspec --allow-warnings --synchronous || exit 1
pod trunk push DriveKitPermissionsUtilsUI.podspec --synchronous || exit 1
pod trunk push DriveKitChallengeUI.podspec --allow-warnings --synchronous || exit 1

