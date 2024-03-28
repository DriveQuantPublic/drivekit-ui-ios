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
import DriveKitVehicleUI
import DriveKitDBVehicleAccessModule
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private static let tag = "DriveKit demo app"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The following line is specific to DriveQuant. Do not copy this code into your project:
        drivequantSpecific(launchOptions: launchOptions)

        // Add AppDelegate as DriveKitDelegate
        DriveKit.shared.addDriveKitDelegate(self)

        // Configuration of DriveKit:
        DriveKitConfig.configure()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Try to repost trips that couldn't be sent to the server previously:
        DriveKitTripAnalysis.shared.checkTripToRepost()
    }
}

private extension AppDelegate {
    // This method is for DriveQuant internal usage. Do not copy it into your code.
    private func drivequantSpecific(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DriveQuantSpecific.initialize()

        let options = launchOptions?.map { $0.key.rawValue }.joined(separator: " ") ?? "none"
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "Application started with options: \(options)")
    }
}

extension AppDelegate: DriveKitDelegate {
    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        DriveKitConfig.logout()
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate, let appNavigationController = appDelegate.window??.rootViewController as? AppNavigationController {
                appNavigationController.setViewControllers([ApiKeyViewController()], animated: true)
            }
        }
    }
}
