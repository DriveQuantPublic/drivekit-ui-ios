//
//  DriveKitDriverDataTimelineUI.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

@objc public class DriveKitDriverDataTimelineUI: NSObject {
    static let tag = "DriveKit Driver Data Timeline UI"

    @objc public static let shared = DriveKitDriverDataTimelineUI()

    @available(*, deprecated, message: "You should use DriveKitUI.shared.scores now")
    public var scores: [DKScoreType] {
        get { DriveKitUI.shared.scores }
        set { DriveKitUI.shared.scores = newValue }
    }
    
    public func initialize() {
        // Nothing to do currently.
    }

    private override init() {
        super.init()
        DriveKitLog.shared.infoLog(tag: DriveKitDriverDataTimelineUI.tag, message: "Initialization")
        DriveKitNavigationController.shared.driverDataTimelineUI = self
    }
}

extension DriveKitDriverDataTimelineUI: DriveKitDriverDataTimelineUIEntryPoint {
    public func getTimelineViewController() -> UIViewController {
        let viewModel = TimelineViewModel()
        viewModel.scoreSelectorViewModel.scores = DriveKitUI.shared.scores
        return TimelineViewController(viewModel: viewModel)
    }
}

extension Bundle {
    static let driverDataTimelineUIBundle = Bundle(identifier: "com.drivequant.drivekit-driverdata-timeline-ui")
}

extension String {
    public func dkDriverDataTimelineLocalized() -> String {
        return self.dkLocalized(tableName: "DriverDataTimelineLocalizable", bundle: Bundle.driverDataTimelineUIBundle ?? .main)
    }
}

@objc(DKUIDriverDataTimelineInitializer)
class DKUIDriverDataTimelineInitializer: NSObject {
    @objc static func initUI() {
        DriveKitDriverDataTimelineUI.shared.initialize()
    }
}
