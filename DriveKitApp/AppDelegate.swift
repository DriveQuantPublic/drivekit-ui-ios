//
//  AppDelegate.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import CoreData
import DriveKitCore
import DriveKitTripAnalysis
import DriveKitDriverData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let tag = "DriveKit test app"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNotificationPermission()
        configureDriveKit(launchOptions: launchOptions)
        return true
    }
    
    private func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func configureDefaultValuesIfNeeded() {
        SettingsBundleKeys.setLoggingPref(logging: false)
        SettingsBundleKeys.setSandboxPref(sandbox: false)
        SettingsBundleKeys.setPositionPref(share: true)
        SettingsBundleKeys.setAutoStartPref(autoStart: true)
        SettingsBundleKeys.setBeaconPref(required: false)
        SettingsBundleKeys.setBeaconConfigPref(configurable: false)
        SettingsBundleKeys.setTimeoutPref(timeout: 4)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DriveKitTripAnalysis.shared.checkTripToRepost()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func configureDriveKit(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DriveKit.shared.initialize()
        DriveKitTripAnalysis.shared.initialize(tripListener: self, appLaunchOptions: launchOptions)
        DriveKitDriverData.shared.initialize()
        if !DriveKit.shared.isConfigured() {
            DriveKit.shared.setApiKey(key: "qDcgo5W2I1p3u5STEhuQ1AJo")
                       self.configureDefaultValuesIfNeeded()
        }
        
        if SettingsBundleKeys.getLoggingPref() {
            DriveKit.shared.enableLogging()
        } else {
            DriveKit.shared.disableLogging()
        }
        DriveKit.shared.enableSandboxMode(enable: SettingsBundleKeys.getSandboxPref())
        DriveKitTripAnalysis.shared.activateAutoStart(enable: SettingsBundleKeys.getAutoStartPref())
        DriveKitTripAnalysis.shared.setStopTimeOut(timeOut: SettingsBundleKeys.getTimeoutPref())
        DriveKitTripAnalysis.shared.setBeaconRequired(required: SettingsBundleKeys.getBeaconPref())
        var beacons: [Beacon] = []
        if SettingsBundleKeys.getBeaconConfigPref() {
             beacons.append(Beacon(proximityUuid: "699ebc80-e1f3-11e3-9a0f-0cf3ee3bc012"))
        }
        DriveKitTripAnalysis.shared.setBeacons(beacons: beacons)
        DriveKitTripAnalysis.shared.enableSharePosition(enable: SettingsBundleKeys.getPositionPref())
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "Configuration refreshed")
    }
}

extension AppDelegate: TripListener {
    func tripStarted(startMode: StartMode) {
        print("Trip Started")
    }
    
    func tripPoint(tripPoint: TripPoint) {
        print("Trip Point")
    }
    
    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        print("Trip Finished")
    }
    
    func tripCancelled(cancelTrip: CancelTrip) {
        print("Trip Cancelled")
    }
    
    func tripSavedForRepost() {
        print("Trip Saved for Repost")
    }
    
    func beaconDetected() {
        print("Trip Beacon Detected")
    }
    
    func significantLocationChangeDetected(location: CLLocation) {
        print("Trip Location significant change detected")
    }
    
    
}
