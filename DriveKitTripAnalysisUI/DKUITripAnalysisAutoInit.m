//
//  DKUITripAnalysisAutoInit.m
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>

@interface DKUITripAnalysisAutoInit : NSObject

@end


@implementation DKUITripAnalysisAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        Class class = NSClassFromString(@"DriveKitTripAnalysisUI.DKUITripAnalysisInitializer");
        [self callMethod:@"initUI" onClass:class];
    }
}

+ (void)callMethod:(NSString*)methodName onClass:(Class)class {
    SEL selector = NSSelectorFromString(methodName);
    IMP imp = [class methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(class, selector);
}

@end
