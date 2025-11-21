#!/bin/bash

pod repo push drivekit-specs DriveKitDriverDataUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverDataTimelineUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverAchievementUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitVehicleUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitPermissionsUtilsUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitChallengeUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitTripAnalysisUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
