//
//  ChallengeTheme.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI

enum ChallengeType {
    case distance
    case duration
    case score
    case nbTrips

    var overviewTitle: String {
        switch self {
        case .distance:
            return "dk_challenge_traveled_distance".dkChallengeLocalized()
        case .duration:
            return "dk_challenge_driving_time".dkChallengeLocalized()
        case .score:
            return ""
        case .nbTrips:
            return "dk_challenge_nb_trip".dkChallengeLocalized()
        }
    }

    var indiceType: String {
        switch self {
        case .distance:
            return DKCommonLocalizable.unitKilometer.text()
        case .duration:
            return ""
        case .score:
            return "/10"
        case .nbTrips:
            return DKCommonLocalizable.tripPlural.text()
        }
    }
}

enum ChallengeTheme {
    case acceleration
    case adherence
    case ecoDriving
    case safety
    case braking
    case distraction
    case none

    var scoreTitle: String {
        switch self {
        case .acceleration:
            return "dk_challenge_acceleration_score".dkChallengeLocalized()
        case .adherence:
            return "dk_challenge_adherence_score".dkChallengeLocalized()
        case .ecoDriving:
            return "dk_challenge_eco_driving_score".dkChallengeLocalized()
        case .safety:
            return "dk_challenge_safety_score".dkChallengeLocalized()
        case .braking:
            return "dk_challenge_braking_score".dkChallengeLocalized()
        case .distraction:
            return "dk_challenge_distraction_score".dkChallengeLocalized()
        case .none:
            return ""
        }
    }
}
