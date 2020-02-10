# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'DriveKitApp' do
  drivekitVersion = '1.3.0-alpha'
  platform :ios, '10.0'
  use_frameworks!
  pod 'Networking', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitCore', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitTripAnalysis', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitDriverData', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'UICircularProgressRing'
end


target 'DriveKitDriverDataUI' do
  drivekitVersion = '1.3.0-alpha'
  platform :ios, '10.0'
  use_frameworks!
  pod 'UICircularProgressRing'
  pod 'DriveKitDriverData', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitTripAnalysis', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitDBTripAccess', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
end

target 'DriveKitDriverAchievementUI' do
  drivekitVersion = '1.3.0-alpha'
  platform :ios, '10.0'
  use_frameworks!
  pod 'DriveKitDriverData', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitTripAnalysis', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
  pod 'DriveKitDBAchievementAccess', :git => 'https://github.com/DriveQuantPublic/drivekit-ios-sdk.git', :tag => drivekitVersion
end

