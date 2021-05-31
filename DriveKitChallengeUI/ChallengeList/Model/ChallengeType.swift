//
//  ChallengeTheme.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 28/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

enum ChallengeType {
    case distance
    case duration
    case score
    case nbTrips

    var overviewTitle: String {
        switch self {
        case .distance:
            return "dk_challenge_driver_distance".dkChallengeLocalized()
        case .duration:
            return "dk_challenge_driver_duration".dkChallengeLocalized()
        case .score:
            return ""
        case .nbTrips:
            return "dk_challenge_driver_trips".dkChallengeLocalized()
        }
    }

    var indiceType: String {
        switch self {
        case .distance:
            return "dk_common_unit_kilometer".dkChallengeLocalized()
        case .duration:
            return ""
        case .score:
            return "/10"
        case .nbTrips:
            return "dk_common_trip_plural".dkChallengeLocalized()
        }
    }
}

enum ChallengeTheme {
    case acceleration
    case adherence
    case ecoDriving
    case security
    case braking
    case distraction
    case none
// TODO: replace keys with the right text
    var scoreTitle: String {
        switch self {
        case .acceleration:
            return "score_acceleration_challenge".dkChallengeLocalized()
        case .adherence:
            return "score_adherence_challenge".dkChallengeLocalized()
        case .ecoDriving:
            return "score_eco_driving_challenge".dkChallengeLocalized()
        case .security:
            return "score_security_challenge".dkChallengeLocalized()
        case .braking:
            return "score_braking_challenge".dkChallengeLocalized()
        case .distraction:
            return "score_distraction_challenge".dkChallengeLocalized()
        case .none:
            return ""
        }
    }
}
