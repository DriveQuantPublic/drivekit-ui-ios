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

end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '1.4-beta12'
  pod 'DriveKitTripAnalysis', '1.4-beta12'
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '1.4-beta12'
end

target 'DriveKitCommonUI' do
  pod 'UICircularProgressRing'
end
  
target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '1.4-beta12'
  pod 'DriveKitTripAnalysis', '1.4-beta12'
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore'
end
