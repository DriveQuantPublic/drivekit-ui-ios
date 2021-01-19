Pod::Spec.new do |s|
  s.name             = 'DriveKitVehicleUI'
  s.version          = '1.6-beta1'
  s.summary          = 'DriveKit Vehicle UI Framework'

  s.description      = 'DriveKit Vehicle features : Vehicles list and detail, beacon and bluetooth management, vehicle selection features'

  s.homepage         = 'https://docs.drivequant.com'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'DriveQuantPublic' => 'jeremy.bayle@drivequant.com' }
  s.swift_version    = '5.0'
  s.source           = { :git => 'https://github.com/DriveQuantPublic/drivekit-ui-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DriveKitVehicleUI/**/*.swift'
  s.resource = ['DriveKitVehicleUI/DriveKitVehicle.xcassets', 'DriveKitVehicleUI/Localizable/*', 'DriveKitVehicleUI/**/*.xib']

  s.dependency 'DriveKitCommonUI', s.version.to_s
  s.dependency 'DriveKitVehicle', '1.9-beta8'
  s.dependency 'DriveKitTripAnalysis', '1.9-beta8'

  s.info_plist = {
    'CFBundleIdentifier' => 'com.drivequant.drivekit-vehicle-ui'
  }
  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.drivequant.drivekit-vehicle-ui'
  }
end
