Pod::Spec.new do |s|
  s.name             = 'DriveKitChallengeUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Challenge UI Framework'

  s.description      = 'DriveKit Challenge features: Display challenges, join challenge, display challenge details'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'DriveKitChallengeUI/**/*.swift'
  s.resource = ['DriveKitChallengeUI/Localizable/*', 'DriveKitChallengeUI/**/*.xib', 'DriveKitChallengeUI/DriveKitChallenge.xcassets']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitChallenge', '1.31-beta7'

  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-challenge-ui'
  }
end
