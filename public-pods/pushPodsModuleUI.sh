#!/bin/bash

pod trunk push DriveKitDriverDataUI.podspec --synchronous
pod trunk push DriveKitDriverAchievementUI.podspec --allow-warnings --synchronous
pod trunk push DriveKitVehicleUI.podspec --allow-warnings --synchronous
pod trunk push DriveKitPermissionsUtilsUI.podspec --synchronous
