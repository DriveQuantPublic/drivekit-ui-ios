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

  s.ios.deployment_target = '11.0'

  s.source_files = 'DriveKitDriverDataTimelineUI/**/*.swift'
  s.resource = ['DriveKitDriverDataTimelineUI/Localizable/*', 'DriveKitDriverDataTimelineUI/**/*.xib', 'DriveKitDriverDataTimelineUI/**/*.storyboard']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitDriverData', '1.31-beta10'
  s.dependency 'ChartsForDK'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-driverdata-timeline-ui'
  }
end
