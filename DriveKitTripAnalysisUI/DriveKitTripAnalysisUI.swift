//
//  DriveKitTripAnalysisUI.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCoreModule
import DriveKitCommonUI
import DriveKitTripAnalysisModule

@objc public class DriveKitTripAnalysisUI: NSObject {
    private(set) var crashFeedbackConfig: DKCrashDetectionFeedbackConfig? = nil
    @objc public static let shared = DriveKitTripAnalysisUI()
    @objc public var defaultWorkingHours: DKWorkingHours = DriveKitTripAnalysisUI.getDefaultWorkingHours()

    @objc public func initialize() {
        DriveKitNavigationController.shared.tripAnalysisUI = self
        DriveKit.shared.registerNotificationDelegate(self)
    }

    private static func getDefaultWorkingHours() -> DKWorkingHours {
        let days: [DKDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        let workingHoursDayConfigurations: [DKWorkingHoursDayConfiguration] = days.map { day in
            DKWorkingHoursDayConfiguration(
                day: day,
                entireDayOff: day == .saturday || day == .sunday,
                startTime: 8,
                endTime: 18,
                reverse: false
            )
        }
        return DKWorkingHours(
            enabled: false,
            insideHours: .business,
            outsideHours: .personal,
            workingHoursDayConfigurations: workingHoursDayConfigurations
        )
    }

    @objc public func disableCrashFeedback() {
        self.crashFeedbackConfig = nil
        DriveKitTripAnalysis.shared.disableCrashFeedback()
    }

    @objc public func enableCrashFeedback(config: DKCrashDetectionFeedbackConfig) {
        self.crashFeedbackConfig = config
        DriveKitTripAnalysis.shared.enableCrashFeedback(config: config.config)
    }

    func getCrashFeedbackViewController(crashInfo: DKCrashInfo) -> UIViewController {
        let viewModel = CrashFeedbackStep1ViewModel(crashInfo: crashInfo)
        return CrashFeedbackStep1VC(viewModel: viewModel)
    }
}

extension DriveKitTripAnalysisUI: DriveKitTripAnalysisUIEntryPoint {
    public func getWorkingHoursViewController() -> UIViewController {
        let workingHoursVC = WorkingHoursViewController()
        return workingHoursVC
    }
}

extension DriveKitTripAnalysisUI: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier: // User did dismiss a notification
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // User did tap a notification
            let content = response.notification.request.content
            self.handleNotificationContent(content: content)
            completionHandler()
        default:
            completionHandler()
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let isForeground = UIApplication.shared.applicationState == .active
        if isForeground {
            let content = notification.request.content
            self.handleNotificationContent(content: content)
        }
        completionHandler(UNNotificationPresentationOptions())
    }

    func handleNotificationContent(content: UNNotificationContent) {
        let categoryIdentifier = content.categoryIdentifier
        if categoryIdentifier == TripAnalysisConstant.crashFeedbackNotificationCategoryIdentifier {
            if let crashId = content.userInfo[TripAnalysisConstant.crashFeedbackNotificationCrashIdKey] as? String {
                if let crashInfo = DriveKitTripAnalysis.shared.crashFeedbackNotificationOpened(crashId: crashId) {
                    print("crashFeedbackNotificationOpened with success")
                    DispatchQueue.main.async { [weak self] in
                        if let crashFeedbackVC = self?.getCrashFeedbackViewController(crashInfo: crashInfo) {
                            let navController = UINavigationController(rootViewController: crashFeedbackVC)
                            navController.modalPresentationStyle = .overFullScreen
                            navController.setNavigationBarHidden(true, animated: false)
                            UIApplication.shared.visibleViewController?.present(navController, animated: false, completion: {
                            })
                        }
                    }
                } else {
                    print("crashFeedbackNotificationOpened with error")
                }
            }
        }
    }
}

extension Bundle {
    static let tripAnalysisUIBundle = Bundle(identifier: "com.drivequant.drivekit-trip-analysis-ui")
}

extension String {
    public func dkTripAnalysisLocalized() -> String {
        return self.dkLocalized(tableName: "DKTripAnalysisLocalizable", bundle: Bundle.tripAnalysisUIBundle ?? .main)
    }
}

extension UIApplication {
    var visibleViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        return getVisibleViewController(rootViewController)
    }

    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        return rootViewController
    }
}
