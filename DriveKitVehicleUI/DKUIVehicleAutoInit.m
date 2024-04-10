//
//  DKUIVehicleAutoInit.m
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitVehicleUI/DriveKitVehicleUI-Swift.h>

SWIFT_CLASS("DKUIVehicleInitializer")
@interface DKUIVehicleInitializer

+ (void)initUI;

@end

@interface DKUIVehicleAutoInit : NSObject

@end


@implementation DKUIVehicleAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIVehicleInitializer initUI];
    }
}

@end
