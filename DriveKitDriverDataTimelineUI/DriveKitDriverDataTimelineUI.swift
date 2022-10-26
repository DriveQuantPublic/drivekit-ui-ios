//
//  DriveKitDriverDataTimelineUI.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

@objc public class DriveKitDriverDataTimelineUI: NSObject {
    @objc public static let shared = DriveKitDriverDataTimelineUI()

    var scores: [DKTimelineScoreType] = [.safety, .ecoDriving, .distraction, .speeding] {
        didSet {
            if self.scores.isEmpty {
                self.scores = [.safety]
            }
        }
    }

    @objc public func getTimelineViewController() -> UIViewController {
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
