#!/bin/bash

pod repo push drivekit-specs DriveKitDriverDataUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git
pod repo push drivekit-specs DriveKitDriverAchievementUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git
pod repo push drivekit-specs DriveKitVehicleUI.podspec --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git
