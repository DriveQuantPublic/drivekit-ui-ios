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
    @objc public static let shared = DriveKitDriverDataTimelineUI()

    public func initialize() {
        DriveKitNavigationController.shared.driverDataTimelineUI = self
    }
}

extension DriveKitDriverDataTimelineUI: DriveKitDriverDataTimelineUIEntryPoint {
    public func getTimelineViewController() -> UIViewController {
        let viewModel = TimelineViewModel()
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
