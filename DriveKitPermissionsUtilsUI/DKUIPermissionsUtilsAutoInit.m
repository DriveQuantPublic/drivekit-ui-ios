//
//  DKUIPermissionsUtilsAutoInit.m
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 22/03/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DriveKitCoreModule/DriveKitCoreModule-Swift.h>

@interface DKUIPermissionsUtilsAutoInit : NSObject

@end


@implementation DKUIPermissionsUtilsAutoInit

+ (void)load {
    [super load];

    if (DriveKit.shared.isAutoInitEnabled) {
        Class class = NSClassFromString(@"DriveKitPermissionsUtilsUI.DKUIPermissionsUtilsInitializer");
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
