// swiftlint:disable no_magic_numbers
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
    static let tag = "DriveKit Trip Analysis UI"

    private(set) var roadsideAssistanceNumber: String?
    @objc public static let shared = DriveKitTripAnalysisUI()
    @objc public var defaultWorkingHours: DKWorkingHours = DriveKitTripAnalysisUI.getDefaultWorkingHours()
    public var tripRecordingUserMode: DKTripRecordingUserMode = .startStop
    private var crashNotifReceivedInForeground: Bool = false
    public var isUserAllowedToStartTripManually: Bool {
        switch tripRecordingUserMode {
        case .startStop, .startOnly:
            return true
        case .stopOnly, .none:
            return false
        }
    }
    public var isUserAllowedToCancelTrip: Bool {
        switch tripRecordingUserMode {
        case .startStop, .stopOnly:
            return true
        case .startOnly, .none:
            return false
        }
    }

    @objc public func initialize() {
        // Nothing to do currently.
    }

    private override init() {
        super.init()
        DriveKitLog.shared.infoLog(tag: DriveKitTripAnalysisUI.tag, message: "Initialization")
        DriveKit.shared.registerNotificationDelegate(self)
        DriveKitNavigationController.shared.tripAnalysisUI = self
    }

    deinit {
        DriveKit.shared.unregisterNotificationDelegate(self)
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
        self.roadsideAssistanceNumber = nil
        DriveKitTripAnalysis.shared.disableCrashFeedback()
    }

    @objc public func enableCrashFeedback(roadsideAssistanceNumber: String, config: DKCrashFeedbackConfig) {
        self.roadsideAssistanceNumber = roadsideAssistanceNumber
        DriveKitTripAnalysis.shared.enableCrashFeedback(config: config)
    }
    
    public func getTripRecordingButton(
        presentedIn presentingVC: UIViewController
    ) -> DKTripRecordingButton {
        let viewModel = DKTripRecordingButtonViewModel(tripRecordingUserMode: self.tripRecordingUserMode)
        let button = DKTripRecordingButton(type: .system)
        button.configure(
            viewModel: viewModel,
            presentingVC: presentingVC
        )
        return button
    }

    func getCrashFeedbackViewController(crashInfo: DKCrashInfo) -> UIViewController {
        let viewModel = CrashFeedbackStep1ViewModel(crashInfo: crashInfo)
        let vc = CrashFeedbackStep1VC(viewModel: viewModel)
        _ = vc.view
        return vc
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

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        self.crashNotifReceivedInForeground = false // reset value for new crash
        let isForeground = UIApplication.shared.applicationState == .active
        if isForeground {
            let content = notification.request.content
            self.handleNotificationContent(content: content)
        }
        self.crashNotifReceivedInForeground = isForeground
        completionHandler(UNNotificationPresentationOptions())
    }

    func handleNotificationContent(content: UNNotificationContent) {
        let categoryIdentifier = content.categoryIdentifier
        if categoryIdentifier == TripAnalysisConstant.crashFeedbackNotificationCategoryIdentifier {
            if let crashId = content.userInfo[TripAnalysisConstant.crashFeedbackNotificationCrashIdKey] as? String {
                if let crashInfo = DriveKitTripAnalysis.shared.crashFeedbackNotificationOpened(crashId: crashId) {
                    DriveKitLog.shared.infoLog(tag: DriveKitTripAnalysisUI.tag, message: "crashFeedbackNotification opened with success")
                    guard !crashNotifReceivedInForeground else {
                        // Crash Feedback View Controller already displayed
                        return
                    }
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
                    DriveKitLog.shared.infoLog(tag: DriveKitTripAnalysisUI.tag, message: "crashFeedbackNotification opened with error")
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

@objc(DKUITripAnalysisInitializer)
class DKUITripAnalysisInitializer: NSObject {
    @objc static func initUI() {
        DriveKitTripAnalysisUI.shared.initialize()
    }
}
