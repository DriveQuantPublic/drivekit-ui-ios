Pod::Spec.new do |s|
  s.name             = 'DriveKitDriverDataUI'
  s.version          = '1.3.0'
  s.summary          = 'DriveKit Driver Data UI Framework'

  s.description      = 'DriveKit Driver Data features : Trip list and detail'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DriveKitDriverDataUI/**/*.swift'
  s.resource = ['DriveKitDriverDataUI/DriverData.xcassets', 'DriveKitDriverDataUI/Localizable/*']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitDriverData'
  s.dependency 'DriveKitTripAnalysis'
  s.resource_bundles = {
    'com.drivequant.drivekit-driverdata-ui' => [
        'DriveKitDriverDataUI/**/*.xib'
    ]
  }
  s.info_plist = {
    'CFBundleIdentifier' => 'com.drivequant.drivekit-driverdata-ui'
  }
end
