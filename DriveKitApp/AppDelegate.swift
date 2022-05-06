//
//  AppDelegate.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitTripAnalysisModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    static let tag = "DriveKit test app"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var options = ""
        if let opt = launchOptions {
            for opti in opt {
                options = "\(options) \(opti.key.rawValue)"
            }
        } else {
            options = "none"
        }
        DriveKitConfig.configure(launchOptions: launchOptions)
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "Application started with options: \(options)")
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        DriveKitTripAnalysis.shared.checkTripToRepost()
    }
}
