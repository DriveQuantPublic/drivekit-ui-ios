Pod::Spec.new do |s|
  s.name             = 'DriveKitDriverAchievementUI'
  s.version          = '1.3.0'
  s.summary          = 'DriveKit Driver Achievement UI Framework'

  s.description      = 'DriveKit Driver Achievement features : Streaks'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DriveKitDriverAchievementUI/**/*.swift'
  s.resource = 'DriveKitDriverAchievementUI/Localizable/*'

  s.dependency 'DriveKitCommonUI', s.version.to_s

  s.info_plist = {
    'CFBundleIdentifier' => 'com.drivequant.drivekit-driver-achievement-ui'
  }
end
