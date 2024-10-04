# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

source 'https://gitlab.com/drivequant/drivekit/drivekit-specs.git'
source 'https://cdn.cocoapods.org/'

def swiftlint
  pod 'SwiftLint'
end

target 'DriveKitApp' do
  pod 'DGCharts', '5.1.0'
  pod 'DriveKitTripSimulator', '2.6-beta2'
  swiftlint
end


target 'DriveKitDriverDataUI' do
  pod 'DriveKitDriverData', '2.6-beta2'
  swiftlint
end

target 'DriveKitDriverDataTimelineUI' do
  pod 'DriveKitDriverData', '2.6-beta2'
  pod 'DGCharts', '5.1.0'
  swiftlint
end

target 'DriveKitDriverAchievementUI' do
  pod 'DriveKitDriverAchievement', '2.6-beta2'
  swiftlint
end

target 'DriveKitCommonUI' do
  pod 'DriveKitCore', '2.6-beta2'
  swiftlint
end

target 'DriveKitVehicleUI' do
  pod 'DriveKitVehicle', '2.6-beta2'
  pod 'DriveKitTripAnalysis', '2.6-beta2'
  swiftlint
end

target 'DriveKitPermissionsUtilsUI' do
  pod 'DriveKitCore', '2.6-beta2'
  swiftlint
end

target 'DriveKitChallengeUI' do
  pod 'DriveKitChallenge', '2.6-beta2'
  swiftlint
end

target 'DriveKitTripAnalysisUI' do
  pod 'DriveKitTripAnalysis', '2.6-beta2'

  pod 'WARangeSlider'
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
