#!/bin/bash

pod repo push drivekit-specs DriveKitDriverDataUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverDataTimelineUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitDriverAchievementUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitVehicleUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitPermissionsUtilsUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitChallengeUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
pod repo push drivekit-specs DriveKitTripAnalysisUI.podspec --verbose --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
