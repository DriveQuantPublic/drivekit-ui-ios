#!/bin/bash

pod repo push drivekit-specs DriveKitCommonUI.podspec --verbose --allow-warnings --sources=https://gitlab.com/drivequant/drivekit/drivekit-specs.git,https://github.com/CocoaPods/Specs.git || exit 1
