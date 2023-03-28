//
//  DKScoreType+Images.swift
//  DriveKitCommonUI
//
//  Created by Frédéric Ruaudel on 17/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import UIKit

extension DKScoreType {
    public func scoreSelectorImage() -> UIImage? {
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
}
