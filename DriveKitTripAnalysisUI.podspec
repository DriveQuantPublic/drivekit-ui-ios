Pod::Spec.new do |s|
  s.name             = 'DriveKitTripAnalysisUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Trip Analysis UI Framework'

  s.description      = 'DriveKit Trip Analysis features: Working hours management'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'DriveKitTripAnalysisUI/**/*.swift'
  s.resource = ['DriveKitTripAnalysisUI/Localizable/*', 'DriveKitTripAnalysisUI/**/*.xib', 'DriveKitTripAnalysisUI/DriveKitTripAnalysis.xcassets', 'DriveKitTripAnalysisUI/PrivacyInfo.xcprivacy']

  s.dependency 'WARangeSlider'
  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitTripAnalysis', '1.39-beta4'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-trip-analysis-ui'
  }
end
