#!/bin/bash

pod repo push drivekit-specs DriveKitDriverDataUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverDataTimelineUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverAchievementUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitVehicleUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitPermissionsUtilsUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitChallengeUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitTripAnalysisUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
