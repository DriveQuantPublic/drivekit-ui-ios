Pod::Spec.new do |s|
  s.name             = 'DriveKitDriverDataTimelineUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Driver Data Timeline UI Framework'

  s.description      = 'DriveKit Driver Data Timeline UI features: Timeline'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = ['DriveKitDriverDataTimelineUI/**/*.swift', 'DriveKitDriverDataTimelineUI/**/*.m']
  s.resource = ['DriveKitDriverDataTimelineUI/Localizable/*', 'DriveKitDriverDataTimelineUI/**/*.xib', 'DriveKitDriverDataTimelineUI/**/*.storyboard', 'DriveKitDriverDataTimelineUI/PrivacyInfo.xcprivacy']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitDriverData', '2.22.0-beta1'
  s.dependency 'DGCharts', '5.1.0'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-driverdata-timeline-ui'
  }
end
