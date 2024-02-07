//
//  ChallengeTheme.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBChallengeAccessModule

extension DKChallengeType {
    var icon: UIImage? {
        switch self {
            case .safety, .hardBraking, .hardAcceleration:
                return DKImages.safetyFlat.image
            case .ecoDriving:
                return DKImages.ecoDrivingFlat.image
            case .distraction:
                return DKImages.distractionFlat.image
            case .speeding:
                return DKImages.speedingFlat.image
            case .deprecated, .unknown:
                return nil
            @unknown default:
                return nil
        }
    }

    var scoreTitle: String {
        switch self {
        case .hardAcceleration:
            return "dk_challenge_acceleration_score".dkChallengeLocalized()
        case .ecoDriving:
            return "dk_challenge_eco_driving_score".dkChallengeLocalized()
        case .safety:
            return "dk_challenge_safety_score".dkChallengeLocalized()
        case .hardBraking:
            return "dk_challenge_braking_score".dkChallengeLocalized()
        case .distraction:
            return "dk_challenge_distraction_score".dkChallengeLocalized()
        case .speeding:
            return "dk_challenge_speeding_score".dkChallengeLocalized()
        case .deprecated, .unknown:
            return ""
        @unknown default:
            return ""
        }
    }

}
