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
    static let calendar = Calendar(identifier: .gregorian)

    private var internalScores: [DKTimelineScoreType] = [.safety, .ecoDriving, .distraction, .speeding]
    var scores: [DKTimelineScoreType] {
        set {
            if newValue.isEmpty {
                self.internalScores = [.safety]
            } else {
                self.internalScores = newValue
            }
        }
        get {
            self.internalScores.filter { score in
                score.hasAccess()
            }
        }
    }

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
