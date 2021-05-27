//
//  ChallengeConditionProgressViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 25/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

enum ChallengeConditionKey: String, CaseIterable {
    case km, nbTrip
}

struct ChallengeConditionProgressViewModel {
    let conditionKey: ChallengeConditionKey
    let value: Double
    let total: Double

    var title: String {
        switch conditionKey {
        case .km:
            return "dk_challenge_distance_kilometer".dkChallengeLocalized()
        case .nbTrip:
            return "dk_challenge_nb_trip".dkChallengeLocalized()
        }
    }

    var progressAttributedString: NSAttributedString {
        let prefix = "\(title): "
        let suffix = "\(Int(value.rounded()))/\(Int(total))"
        let progress = prefix + suffix

        let suffixRange = (progress as NSString).range(of: suffix)
        let attributedString = NSMutableAttributedString(string: progress, attributes: [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16), NSAttributedString.Key.foregroundColor: UIColor.black])

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: DKUIColors.primaryColor.color, range: suffixRange)
        return attributedString
    }

    var progressValue: Float {
        return Float(value/total)
    }

    static func getConditionsViewModel(conditions: [String: Any], driverConditions:[String: Any]) -> [String: ChallengeConditionProgressViewModel] {
        var resultDict: [String: ChallengeConditionProgressViewModel] = [:]
        for key in ChallengeConditionKey.allCases {
            if let value: Double = conditions[key.rawValue] as? Double, let driverValue: Double = driverConditions[key.rawValue] as? Double {
                resultDict[key.rawValue] = ChallengeConditionProgressViewModel(conditionKey: key, value: driverValue, total: value)
            }
        }
        return resultDict
    }
}
