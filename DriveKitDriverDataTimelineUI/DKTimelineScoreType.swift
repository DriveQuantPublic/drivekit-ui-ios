//
//  DKTimelineScoreType.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 17/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule

@objc public enum DKTimelineScoreType: Int {
    case safety, ecoDriving, distraction, speeding
}

extension DKTimelineScoreType {
    public func image() -> UIImage? {
        switch self {
            case .ecoDriving:
                return DKImages.ecoDrivingFlat.image
            case .safety:
                return DKImages.safetyFlat.image
            case .distraction:
                return DKImages.distractionFlat.image
            case .speeding:
                return DKImages.speedingFlat.image
        }
    }

    func hasAccess() -> Bool {
        switch self {
            case .distraction:
                return DriveKitAccess.shared.hasAccess(.phoneDistraction)
            case .ecoDriving:
                return DriveKitAccess.shared.hasAccess(.ecoDriving)
            case .safety:
                return DriveKitAccess.shared.hasAccess(.safety)
            case .speeding:
                return DriveKitAccess.shared.hasAccess(.speeding)
        }
    }
}
