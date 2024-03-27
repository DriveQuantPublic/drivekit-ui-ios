//
//  DKUIDriverAchievementAutoInit.m
//  DriveKitDriverAchievementUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitDriverAchievementUI/DriveKitDriverAchievementUI-Swift.h>

SWIFT_CLASS("DKUIDriverAchievementInitializer")
@interface DKUIDriverAchievementInitializer

+ (void)initUI;

@end

@interface DKUIDriverAchievementAutoInit : NSObject

@end


@implementation DKUIDriverAchievementAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIDriverAchievementInitializer initUI];
    }
}

@end
