# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

#source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

def circular_progress_ring
  pod 'UICircularProgressRing', '6.5.0'
end

target 'DriveKitApp' do

end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData'
  circular_progress_ring
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement'
  circular_progress_ring
end

target 'DriveKitCommonUI' do
  pod 'DriveKitCore'
  circular_progress_ring
end
  
target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle'
  pod 'DriveKitTripAnalysis'
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore'
end

target 'DriveKitChallengeUI' do
  pod 'DriveKitChallenge'
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
