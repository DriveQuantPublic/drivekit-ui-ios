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
        var options = ""
        if let opt = launchOptions {
            for opti in opt {
                options = "\(options) \(opti.key.rawValue)"
            }
        }else{
            options = "none"
        }
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "Application started with options : \(options)")
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
            DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "DriveKit configured with API key")
        }
    }
}

extension AppDelegate: TripListener {
    func tripStarted(startMode: StartMode) {
        NotificationSender.shared.sendNotification(message: "trip_started".keyLocalized())
    }
    
    func tripPoint(tripPoint: TripPoint) {
        print("New trip point")
    }
    
    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        if response.itineraryStatistics?.transportationMode == TransportationMode.train.rawValue {
            NotificationSender.shared.sendNotification(message: "train_trip".keyLocalized())
        }else{
            NotificationSender.shared.sendNotification(message: "trip_finished".keyLocalized())
        }
    }
    
    func tripCancelled(cancelTrip: CancelTrip) {
        NotificationSender.shared.sendNotification(message: cancelTrip.reason())
    }
    
    func tripSavedForRepost() {
        NotificationSender.shared.sendNotification(message: "trip_save_for_repost".keyLocalized())
    }
    
    func beaconDetected() {
        print("Trip Beacon Detected")
    }
    
    func significantLocationChangeDetected(location: CLLocation) {
        print("Trip Location significant change detected")
    }
    
    
}

extension CancelTrip {
    func reason() -> String{
        switch self {
        case .beaconNoSpeed, .noSpeed, .noGPSData:
            return "trip_cancelled_no_gps_data".keyLocalized()
        case .user:
            return "trip_cancelled_user".keyLocalized()
        case .highspeed:
            return "trip_cancelled_highspeed".keyLocalized()
        case .noBeacon:
            return "trip_cancelled_no_beacon".keyLocalized()
        case .reset,.missingConfiguration:
            return "trip_cancelled_reset".keyLocalized()
        }
    }
}

extension String {
   func keyLocalized() -> String {
        let localizedValue = Bundle.main.localizedString(forKey: self, value: NSLocalizedString(self, comment: ""), table: "Localizable")
        return localizedValue
    }
}
