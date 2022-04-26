//
//  AppDelegate.swift
//  DriveKitApp
//
//  Created by Meryl Barantal on 22/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import CoreData
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitDriverDataModule
import CoreLocation
import DriveKitDBTripAccessModule
import DriveKitCommonUI
import DriveKitDriverAchievementUI
import DriveKitDriverDataUI
import DriveKitVehicleUI
import DriveKitVehicleModule
import DriveKitDBVehicleAccessModule
import DriveKitPermissionsUtilsUI
import DriveKitChallengeUI
import DriveKitTripAnalysisUI

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
        requestNotificationPermission()
        TripListenerManager.shared.addTripListener(self)
        configureDriveKit(launchOptions: launchOptions)
        DriveKitUI.shared.initialize(colors: DefaultColors(), fonts: DefaultFonts(), overridedStringsFileName: "Localizable")
        DriveKitDriverAchievementUI.shared.initialize()
        DriveKitDriverAchievementUI.shared.configureRankingTypes([.safety, .ecoDriving, .distraction, .speeding])
        DriveKitDriverAchievementUI.shared.configureRankingSelector(DKRankingSelectorType.period(rankingPeriods: [.weekly, .monthly, .allTime]))
        DriveKitDriverDataUI.shared.initialize()
        DriveKitDriverDataUI.shared.enableAlternativeTrips(true)
        DriveKitVehicleUI.shared.initialize()
        DriveKitVehicleUI.shared.configureBeaconDetailEmail(beaconDiagnosticEmail: self)
        DriveKitVehicleUI.shared.configureBeaconDiagnosticSupportURL(url: "https://www.google.com")
        DriveKitVehicleUI.shared.configureCategoryConfigType(type: .bothConfig)
        DriveKitVehicleUI.shared.addCustomVehicleField(groupField: .engine, fieldsToAdd: [DeclaredConsumptionField()])
        DriveKitVehicleUI.shared.addCustomVehicleField(groupField: .characteristics, fieldsToAdd: [DeclaredPtacField()])
        DriveKitVehicleUI.shared.enableOdometer(true)
        DriveKitPermissionsUtilsUI.shared.initialize()
        DriveKitPermissionsUtilsUI.shared.configureBluetooth(needed: true)
        DriveKitPermissionsUtilsUI.shared.configureContactType(DKContactType.email(self))
        DriveKitChallengeUI.shared.initialize()
        DriveKitTripAnalysisUI.shared.initialize()
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "Application started with options : \(options)")
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
        DriveKit.shared.initialize(delegate: DriveKitDelegateManager.shared)
        if DriveKit.shared.isLoggingEnabled() {
            DriveKit.shared.enableLogging()
        }
        DriveKitTripAnalysis.shared.initialize(tripListener: TripListenerManager.shared, appLaunchOptions: launchOptions)
        DriveKitDriverData.shared.initialize()
        var apiKey = "ENTER_YOUR_API_KEY_HERE"
        apiKey.replaceApiKeyIfNeeded()
        DriveKit.shared.setApiKey(key: apiKey)
        DriveKitTripAnalysis.shared.setVehiclesConfigTakeover(vehiclesConfigTakeOver: false)
        
        DriveKitLog.shared.infoLog(tag: AppDelegate.tag, message: "DriveKit configured with API key")
        if SettingsBundleKeys.getDefaultValuePref() {
            // DriveKit default value
            SettingsBundleKeys.setSandboxPref(sandbox: false)
            SettingsBundleKeys.setPositionPref(share: false)
            SettingsBundleKeys.setAutoStartPref(autoStart: true)
            SettingsBundleKeys.setBeaconPref(required: false)
            SettingsBundleKeys.setBeaconConfigPref(configurable: false)
            SettingsBundleKeys.setTimeoutPref(timeout: 4)
            SettingsBundleKeys.setDefaultValuePref(share: false)
            DriveKitTripAnalysis.shared.activateAutoStart(enable: true)
            DriveKitTripAnalysis.shared.enableSharePosition(enable: false)
            DriveKitTripAnalysis.shared.setBeaconRequired(required: false)
            DriveKitTripAnalysis.shared.setStopTimeOut(timeOut: 4 * 60)
            DriveKitTripAnalysis.shared.setBeacons(beacons: [])
        } else {
            DriveKitTripAnalysis.shared.activateAutoStart(enable: SettingsBundleKeys.getAutoStartPref())
        }

        DriveKitTripAnalysis.shared.activateCrashDetection(true)
        let crashFeedbackConfig = DKCrashFeedbackConfig(notification: DKCrashFeedbackNotification(title: "dk_crash_detection_feedback_notif_title".dkTripAnalysisLocalized(), message: "dk_crash_detection_feedback_notif_message".dkTripAnalysisLocalized(), crashAlert: .vibration))
        DriveKitTripAnalysisUI.shared.enableCrashFeedback(roadsideAssistanceNumber: "000000", config: crashFeedbackConfig)
    }
}

extension AppDelegate: TripListener {
    func sdkStateChanged(state: State) {
        
    }
    
    func tripStarted(startMode: StartMode) {
        NotificationSender.shared.sendNotification(message: "\("trip_started".keyLocalized()) : \(startMode.rawValue)")
    }
    
    func tripPoint(tripPoint: TripPoint) {
        print("New trip point")
    }
    
    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        if response.itineraryStatistics?.transportationMode == TransportationMode.train.rawValue {
            NotificationSender.shared.sendNotification(message: "train_trip".keyLocalized())
        } else {
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

    func potentialTripStart(startMode: StartMode) {
        print("Potential Trip Start")
    }

    func crashDetected(crashInfo: DKCrashInfo) {
        print("Crash Detected")
    }
    
    func crashFeedbackSent(crashInfo: DKCrashInfo, feedbackType: DKCrashFeedbackType, severity: DKCrashFeedbackSeverity) {
        print("Crash Feedback Sent")
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
        @unknown default:
            return ""
        }
    }
}

class DefaultColors: DKDefaultColors {
}

class DefaultFonts: DKDefaultFonts {
}

extension AppDelegate: DKContentMail {
    func overrideMailBodyContent() -> Bool {
        return false
    }
    
    func getRecipients() -> [String] {
        return ["recipient_to_configure@mail.com"]
    }
    
    func getBccRecipients() -> [String] {
        return []
    }
    
    func getSubject() -> String {
        return "[Subject to configure]"
    }
    
    func getMailBody() -> String {
        return "[Mail body to configure]"
    }
}

fileprivate class DeclaredConsumptionField: DKVehicleField {
    var isEditable: Bool = true
    var keyBoardType: UIKeyboardType = .decimalPad
    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return !vehicle.isTruck()
    }
    func getTitle(vehicle: DKVehicle) -> String { "title_declared_consumption".keyLocalized() }
    func getDescription(vehicle: DKVehicle) -> String? { nil }
    func getValue(vehicle: DKVehicle) -> String? {
        return vehicle.extraData["declaredConsumption"]
    }
    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        if let consumption = value.doubleValue() {
            return consumption > 2 && consumption < 20
        } else {
            return false
        }
    }
    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        return "error_consumption".keyLocalized()
    }
    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

fileprivate class DeclaredPtacField: DKVehicleField {
    var isEditable: Bool = true
    var keyBoardType: UIKeyboardType = .decimalPad
    func isDisplayable(vehicle: DKVehicle) -> Bool {
        return vehicle.isTruck()
    }
    func getTitle(vehicle: DKVehicle) -> String { "dk_vehicle_ptac_truck_and_trailer".dkVehicleLocalized() }
    func getDescription(vehicle: DKVehicle) -> String? { "dk_vehicle_ptac_truck_and_trailer_info".dkVehicleLocalized() }
    func getValue(vehicle: DKVehicle) -> String? {
        return vehicle.extraData["declaredPtac"]
    }
    func isValid(value: String, vehicle: DKVehicle) -> Bool {
        if let declaredPtac = value.doubleValue() {
            let mass = vehicle.mass / 1000
            return declaredPtac >= mass && declaredPtac <= 44
        } else {
            return false
        }
    }
    func getErrorDescription(value: String, vehicle: DKVehicle) -> String? {
        if let declaredPtac = value.doubleValue() {
            if declaredPtac < vehicle.mass / 1000 {
                return "dk_vehicle_ptac_truck_and_trailer_alert_min".dkVehicleLocalized()
            } else if declaredPtac > 44 {
                return "dk_vehicle_ptac_truck_and_trailer_alert_max".dkVehicleLocalized()
            }
        }
        return nil
    }
    func onFieldUpdated(value: String, vehicle: DKVehicle, completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}
