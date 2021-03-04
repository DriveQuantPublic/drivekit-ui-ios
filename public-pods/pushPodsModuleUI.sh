#!/bin/bash

pod trunk push DriveKitDriverDataUI.podspec
pod trunk push DriveKitDriverAchievementUI.podspec --allow-warnings
pod trunk push DriveKitVehicleUI.podspec --allow-warnings
pod trunk push DriveKitPermissionsUtilsUI.podspec
