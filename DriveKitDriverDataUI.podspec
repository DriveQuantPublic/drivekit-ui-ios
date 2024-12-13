Pod::Spec.new do |s|
  s.name             = 'DriveKitDriverDataUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Driver Data UI Framework'

  s.description      = 'DriveKit Driver Data features : Trip list and detail'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = ['DriveKitDriverDataUI/**/*.swift', 'DriveKitDriverDataUI/**/*.m']
  s.resource = ['DriveKitDriverDataUI/DriverData.xcassets', 'DriveKitDriverDataUI/Localizable/*', 'DriveKitDriverDataUI/**/*.xib', 'DriveKitDriverDataUI/**/*.storyboard', 'DriveKitDriverDataUI/PrivacyInfo.xcprivacy']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitDriverData', '2.9-beta3'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-driverdata-ui'
  }
end
