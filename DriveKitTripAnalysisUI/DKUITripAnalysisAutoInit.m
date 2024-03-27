//
//  DKUITripAnalysisAutoInit.m
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>
#import <DriveKitTripAnalysisUI/DriveKitTripAnalysisUI-Swift.h>

SWIFT_CLASS("DKUITripAnalysisInitializer")
@interface DKUITripAnalysisInitializer

+ (void)initUI;

@end

@interface DKUITripAnalysisAutoInit : NSObject

@end


@implementation DKUITripAnalysisAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        [DKUITripAnalysisInitializer initUI];
    }
}

@end
