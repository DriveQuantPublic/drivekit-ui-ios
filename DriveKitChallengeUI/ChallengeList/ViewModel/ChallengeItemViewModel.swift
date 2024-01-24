// swiftlint:disable no_magic_numbers
//
//  ChallengeItemViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 03/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI
import UIKit

struct ChallengeItemViewModel {
    let startDate: Date
    let endDate: Date
    let name: String
    let image: UIImage?
    let identifier: String
    let conditionsFilled: Bool
    let registered: Bool
    let nbDriverRegistered: Int
    let rank: Int
    let theme: DKChallengeType

    init(challenge: DKChallenge) {
        identifier = challenge.id
        startDate = challenge.startDate
        endDate = challenge.endDate
        name = challenge.title
        self.theme = DKChallengeType.from(themeCode: challenge.themeCode)
        self.image = self.theme.icon
        self.registered = challenge.isRegistered
        self.conditionsFilled = challenge.conditionsFilled
        self.rank = challenge.rank
        self.nbDriverRegistered = challenge.nbDriverRegistered
    }

    static func formatStartAndEndDates(startDate: Date,
                                       endDate: Date,
                                       tintColor: UIColor,
                                       alignment: NSTextAlignment = NSTextAlignment.left) -> NSMutableAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        return NSMutableAttributedString(
            string: "\(startDate.format(pattern: .standardDate)) - \(endDate.format(pattern: .standardDate))",
            attributes: [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14),
                         NSAttributedString.Key.foregroundColor: tintColor,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }

    var participationMessage: String {
        let now = Date()
        let minParticipantsNumberToDisplay: Int = 100
        if now.timeIntervalSince(self.startDate) < 0 {
            // challenge has not started yet
            if self.registered {
                if self.nbDriverRegistered >= minParticipantsNumberToDisplay {
                    return String(format: "dk_challenge_list_registered_among".dkChallengeLocalized(), self.nbDriverRegistered)
                } else {
                    return "dk_challenge_list_registered".dkChallengeLocalized()
                }
            } else {
                if self.nbDriverRegistered >= minParticipantsNumberToDisplay {
                    return String(format: "dk_challenge_list_join_among".dkChallengeLocalized(), self.nbDriverRegistered)
                } else {
                    return "dk_challenge_list_join".dkChallengeLocalized()
                }
            }
        } else if now.timeIntervalSince(self.endDate) < 0 {
            // challenge has not ended yet (active)
            if self.registered {
                if self.conditionsFilled {
                    return String(format: "dk_challenge_list_ranked".dkChallengeLocalized(), self.rank, self.nbDriverRegistered)
                } else {
                    if self.nbDriverRegistered >= minParticipantsNumberToDisplay {
                        return String(format: "dk_challenge_list_registered_among".dkChallengeLocalized(), self.nbDriverRegistered)
                    } else {
                        return "dk_challenge_list_registered".dkChallengeLocalized()
                    }
                }
            } else {
                if self.nbDriverRegistered >= minParticipantsNumberToDisplay {
                    return String(format: "dk_challenge_list_join_among".dkChallengeLocalized(), self.nbDriverRegistered)
                } else {
                    return "dk_challenge_list_join".dkChallengeLocalized()
                }
            }
        } else {
            if self.registered {
                if conditionsFilled {
                    return String(format: "dk_challenge_list_ranked".dkChallengeLocalized(), self.rank, self.nbDriverRegistered)
                } else {
                    return "dk_challenge_list_not_ranked".dkChallengeLocalized()
                }
            } else {
                return "dk_challenge_list_not_registered".dkChallengeLocalized()
            }
        }
    }
}
