# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

#pod 'Networking', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
# pod 'DriveKitCore', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
# pod 'DriveKitTripAnalysis', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
# pod 'DriveKitDriverData', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion


target 'DriveKitApp' do
  drivekitVersion = '1.3.1'
  platform :ios, '10.0'
  use_frameworks!
  pod 'DriveKitTripAnalysis', drivekitVersion
  pod 'DriveKitDriverData', drivekitVersion
end


target 'DriveKitDriverDataUI' do
  drivekitVersion = '1.3.1'
  platform :ios, '10.0'
  use_frameworks!
  pod 'UICircularProgressRing'
  pod 'DriveKitDriverData', drivekitVersion
  pod 'DriveKitTripAnalysis', drivekitVersion
end

target 'DriveKitDriverAchievementUI' do
  drivekitVersion = '1.3.1'
  platform :ios, '10.0'
  use_frameworks!
  pod 'DriveKitDriverAchievement', drivekitVersion
end

target 'DriveKitCommonUI' do
  platform :ios, '10.0'
  pod 'UICircularProgressRing'
end
