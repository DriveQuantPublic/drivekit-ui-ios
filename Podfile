# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

#source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

def circular_progress_ring
  pod 'UICircularProgressRing', '6.5.0'
end

target 'DriveKitApp' do
  pod 'ChartsForDK', :git => 'https://github.com/DriveQuantPublic/Charts-ios11.git', :branch => 'feature/ChartsForDK'
  pod 'DriveKitTripSimulator', '1.29-beta1'
end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '1.29-beta1'
  circular_progress_ring
end

target 'DriveKitDriverDataTimelineUI' do
  pod 'DriveKitDriverData', '1.29-beta1'
  pod 'ChartsForDK', :git => 'https://github.com/DriveQuantPublic/Charts-ios11.git', :branch => 'feature/ChartsForDK'
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '1.29-beta1'
  circular_progress_ring
end

target 'DriveKitCommonUI' do
  pod 'DriveKitCore', '1.29-beta1'
  circular_progress_ring
end

target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '1.29-beta1'
  pod 'DriveKitTripAnalysis', '1.29-beta1'
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore', '1.29-beta1'
end

target 'DriveKitChallengeUI' do
  pod 'DriveKitChallenge', '1.29-beta1'
end

target 'DriveKitTripAnalysisUI' do
  pod 'DriveKitTripAnalysis', '1.29-beta1'

  pod 'WARangeSlider'
  circular_progress_ring
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end
