//
//  DKUIChallengeAutoInit.m
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitChallengeUI/DriveKitChallengeUI-Swift.h>

SWIFT_CLASS("DKUIChallengeInitializer")
@interface DKUIChallengeInitializer

+ (void)initUI;

@end

@interface DKUIChallengeAutoInit : NSObject

@end


@implementation DKUIChallengeAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUIChallengeInitializer initUI];
    }
}

@end
