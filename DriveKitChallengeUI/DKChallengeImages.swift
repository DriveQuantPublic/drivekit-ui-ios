// swiftlint:disable no_magic_numbers cyclomatic_complexity
//
//  DKChallengeImages.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 18/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKChallengeImages: String {
    case firstDriver = "dk_challenge_first_driver",
         result = "dk_challenge_result",
         leaderboard = "dk_challenge_leaderboard",
         trip = "dk_challenge_trip",
         rules = "dk_challenge_rules",
         leaderboardSafety = "dk_challenge_leaderboard_safety",
         leaderboardDistraction = "dk_challenge_leaderboard_distraction",
         leaderboardEcodriving = "dk_challenge_leaderboard_ecodriving",
         leaderboardSpeeding = "dk_challenge_leaderboard_speeding",
         finished = "dk_challenge_finished",
         general101Trophy = "dk_challenge_general_101_trophy",
         general102Medal = "dk_challenge_general_102_medal",
         general103MdealFirst = "dk_challenge_general_103_medal_first",
         general104LeaderBoard = "dk_challenge_general_104_leader_board",
         general105SteeringWheel = "dk_challenge_general_105_steering_wheel",
         ecoDrive301Leaf = "dk_challenge_eco_drive_301_leaf",
         ecoDrive302Natural = "dk_challenge_eco_drive_302_natural",
         ecoDrive303GasPump = "dk_challenge_eco_drive_303_gas_pump",
         ecoDrive304GasStation = "dk_challenge_eco_drive_304_gas_station",
         safety401Shield = "dk_challenge_safety_401_shield",
         safety402Tire = "dk_challenge_safety_402_tire",
         safety403Wheel = "dk_challenge_safety_403_wheel",
         safety404BrakeWarning = "dk_challenge_safety_404_brake_warning",
         safety405Speedometer01 = "dk_challenge_safety_405_speedometer01",
         safety406Speedometer02 = "dk_challenge_safety_406_speedometer02",
         safety407MaximumSpeed = "dk_challenge_safety_407_maximum_speed",
         safety408TrafficLight = "dk_challenge_safety_408_traffic_light"

    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .challengeUIBundle, compatibleWith: nil)
        }
    }

    static func imageForTheme(iconCode: Int) -> DKChallengeImages {
        switch iconCode {
        case 101:
            return .general101Trophy
        case 102:
            return .general102Medal
        case 103:
            return .general103MdealFirst
        case 104:
            return .general104LeaderBoard
        case 105:
            return .general105SteeringWheel
        case 301:
            return .ecoDrive301Leaf
        case 302:
            return .ecoDrive302Natural
        case 303:
            return .ecoDrive303GasPump
        case 304:
            return .ecoDrive304GasStation
        case 401:
            return .safety401Shield
        case 402:
            return .safety402Tire
        case 403:
            return .safety403Wheel
        case 404:
            return .safety404BrakeWarning
        case 405:
            return .safety405Speedometer01
        case 406:
            return .safety406Speedometer02
        case 407:
            return .safety407MaximumSpeed
        case 408:
            return .safety408TrafficLight
        default:
            return .general101Trophy
        }
    }
}
