# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

def circular_progress_ring
  pod 'UICircularProgressRing', '6.5.0'
end

target 'DriveKitApp' do
  pod 'DriveKitTripSimulator', '1.25-beta1'
  pod 'Charts'
end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '1.25-beta1'
  circular_progress_ring
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '1.25-beta1'
  circular_progress_ring
end

target 'DriveKitCommonUI' do
  pod 'DriveKitCore', '1.25-beta1'
  circular_progress_ring
end

target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '1.25-beta1'
  pod 'DriveKitTripAnalysis', '1.25-beta1'
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore', '1.25-beta1'
end

target 'DriveKitChallengeUI' do
  pod 'DriveKitChallenge', '1.25-beta1'
end

target 'DriveKitTripAnalysisUI' do
  pod 'DriveKitTripAnalysis', '1.25-beta1'
  pod 'WARangeSlider'
  circular_progress_ring
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
