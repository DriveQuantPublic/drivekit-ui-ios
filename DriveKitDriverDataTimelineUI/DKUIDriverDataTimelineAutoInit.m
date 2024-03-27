//
//  DKUIDriverDataTimelineAutoInit.m
//  DriveKitDriverDataTimelineUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitDriverDataTimelineUI/DriveKitDriverDataTimelineUI-Swift.h>

SWIFT_CLASS("DKUIDriverDataTimelineInitializer")
@interface DKUIDriverDataTimelineInitializer

+ (void)initUI;

@end

@interface DKUIDriverDataTimelineAutoInit : NSObject

@end


@implementation DKUIDriverDataTimelineAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIDriverDataTimelineInitializer initUI];
    }
}

@end
