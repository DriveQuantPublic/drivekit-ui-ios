# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'DriveKitApp' do

end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '1.11-beta4'
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '1.11-beta4'
  pod 'UICircularProgressRing'
end

target 'DriveKitCommonUI' do
  pod 'UICircularProgressRing'
end
  
target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '1.11-beta4'
  pod 'DriveKitTripAnalysis', '1.11-beta4'
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore', '1.11-beta4'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
