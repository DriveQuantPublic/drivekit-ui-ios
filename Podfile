# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

def circular_progress_ring
  pod 'UICircularProgressRingForDK', '6.5.1'
end

def swiftlint
  pod 'SwiftLint'
end

target 'DriveKitApp' do
  pod 'ChartsForDK', '3.6.1'
  pod 'DriveKitTripSimulator', '1.36-beta2'
  swiftlint
end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '1.36-beta2'
  circular_progress_ring
  swiftlint
end

target 'DriveKitDriverDataTimelineUI' do
  pod 'DriveKitDriverData', '1.36-beta2'
  pod 'ChartsForDK', '3.6.1'
  swiftlint
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '1.36-beta2'
  circular_progress_ring
  swiftlint
end

target 'DriveKitCommonUI' do
  pod 'DriveKitCore', '1.36-beta2'
  circular_progress_ring
  swiftlint
end

target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '1.36-beta2'
  pod 'DriveKitTripAnalysis', '1.36-beta2'
  swiftlint
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore', '1.36-beta2'
  swiftlint
end

target 'DriveKitChallengeUI' do
  pod 'DriveKitChallenge', '1.36-beta2'
  swiftlint
end

target 'DriveKitTripAnalysisUI' do
  pod 'DriveKitTripAnalysis', '1.36-beta2'

  pod 'WARangeSlider'
  circular_progress_ring
  swiftlint
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
