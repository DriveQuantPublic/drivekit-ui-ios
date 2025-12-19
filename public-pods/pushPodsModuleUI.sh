#!/bin/bash

pod trunk push DriveKitDriverDataUI.podspec --synchronous || exit 1
pod trunk push DriveKitDriverDataTimelineUI.podspec --synchronous || exit 1
pod trunk push DriveKitDriverAchievementUI.podspec --synchronous || exit 1
pod trunk push DriveKitVehicleUI.podspec --synchronous || exit 1
pod trunk push DriveKitPermissionsUtilsUI.podspec --synchronous || exit 1
pod trunk push DriveKitChallengeUI.podspec --synchronous || exit 1
pod trunk push DriveKitTripAnalysisUI.podspec --synchronous || exit 1

