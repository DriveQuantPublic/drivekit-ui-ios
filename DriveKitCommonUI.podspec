Pod::Spec.new do |s|
  s.name             = 'DriveKitCommonUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Common UI Framework'

  s.description      = 'Common features of all DriveKit UI modules'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = ['DriveKitCommonUI/**/*.swift', 'DriveKitCommonUI/**/*.m']
  s.resource = ['DriveKitCommonUI/Graphical/DKImages.xcassets','DriveKitCommonUI/Graphical/*.ttf', 'DriveKitCommonUI/Localizable/*','DriveKitCommonUI/**/*.xib','DriveKitCommonUI/AnalyticsScreenToTagKey.plist','DriveKitCommonUI/AnalyticsTags.plist', 'DriveKitCommonUI/PrivacyInfo.xcprivacy']
  s.frameworks = "CoreText"

  s.dependency 'DriveKitCore'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-common-ui'
  }
end
