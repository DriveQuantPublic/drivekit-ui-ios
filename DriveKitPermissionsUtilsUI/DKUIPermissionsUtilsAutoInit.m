//
//  DKUIPermissionsUtilsAutoInit.m
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitPermissionsUtilsUI/DriveKitPermissionsUtilsUI-Swift.h>

SWIFT_CLASS("DKUIPermissionsUtilsInitializer")
@interface DKUIPermissionsUtilsInitializer

+ (void)initUI;

@end

@interface DKUIPermissionsUtilsAutoInit : NSObject

@end


@implementation DKUIPermissionsUtilsAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIPermissionsUtilsInitializer initUI];
    }
}

@end
