//
//  DKUIDriverDataAutoInit.m
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 21/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitDriverDataUI/DriveKitDriverDataUI-Swift.h>

SWIFT_CLASS("DKUIDriverDataInitializer")
@interface DKUIDriverDataInitializer

+ (void)initUI;

@end

@interface DKUIDriverDataAutoInit : NSObject

@end


@implementation DKUIDriverDataAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIDriverDataInitializer initUI];
    }
}

@end
