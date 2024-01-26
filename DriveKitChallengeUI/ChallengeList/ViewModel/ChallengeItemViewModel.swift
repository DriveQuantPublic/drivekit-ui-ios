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
    let type: DKChallengeType

    init(challenge: DKChallenge) {
        identifier = challenge.id
        startDate = challenge.startDate
        endDate = challenge.endDate
        name = challenge.title
        self.type = challenge.type
        self.image = self.type.icon
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

    var participationMessage: NSAttributedString {
        let now = Date()
        let minParticipantsNumberToDisplay: Int = 100
        let flatMessage: String
        var isRankingMessage: Bool = false
        var containsParticipants: Bool = false
        if now.timeIntervalSince(self.startDate) < 0 {
            // challenge has not started yet
            if self.registered {
                if self.nbDriverRegistered > minParticipantsNumberToDisplay {
                    flatMessage = String(format: "dk_challenge_list_registered_among".dkChallengeLocalized(), self.nbDriverRegistered)
                    containsParticipants = true
                } else {
                    flatMessage = "dk_challenge_list_registered".dkChallengeLocalized()
                }
            } else {
                if self.nbDriverRegistered > minParticipantsNumberToDisplay {
                    flatMessage = String(format: "dk_challenge_list_join_among".dkChallengeLocalized(), self.nbDriverRegistered)
                    containsParticipants = true
                } else {
                    flatMessage = "dk_challenge_list_join".dkChallengeLocalized()
                }
            }
        } else if now.timeIntervalSince(self.endDate) < 0 {
            // challenge has not ended yet (active)
            if self.registered {
                if self.conditionsFilled {
                    flatMessage = String(format: "dk_challenge_list_ranked".dkChallengeLocalized(), self.rank, self.nbDriverRegistered)
                    isRankingMessage = true
                } else {
                    if self.nbDriverRegistered > minParticipantsNumberToDisplay {
                        flatMessage = String(format: "dk_challenge_list_registered_among".dkChallengeLocalized(), self.nbDriverRegistered)
                        containsParticipants = true
                    } else {
                        flatMessage = "dk_challenge_list_registered".dkChallengeLocalized()
                    }
                }
            } else {
                if self.nbDriverRegistered > minParticipantsNumberToDisplay {
                    flatMessage = String(format: "dk_challenge_list_join_among".dkChallengeLocalized(), self.nbDriverRegistered)
                    containsParticipants = true
                } else {
                    flatMessage = "dk_challenge_list_join".dkChallengeLocalized()
                }
            }
        } else {
            if self.registered {
                if conditionsFilled {
                    flatMessage = String(format: "dk_challenge_list_ranked".dkChallengeLocalized(), self.rank, self.nbDriverRegistered)
                    isRankingMessage = true
                } else {
                    flatMessage = "dk_challenge_list_not_ranked".dkChallengeLocalized()
                }
            } else {
                flatMessage = "dk_challenge_list_not_registered".dkChallengeLocalized()
            }
        }
        let numbersAttributes = [
            NSAttributedString.Key.font: DKStyles.highlightSmall.style.applyTo(font: .primary),
            NSAttributedString.Key.foregroundColor: DKUIColors.secondaryColor.color
        ]

        let participationAttributedString: NSMutableAttributedString
        if isRankingMessage {
            participationAttributedString = flatMessage.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.secondaryColor).build()

            let rankRange = (flatMessage  as NSString).range(of: "\(self.rank)")
            participationAttributedString.setAttributes(numbersAttributes, range: rankRange)

            let participantsRange = (flatMessage  as NSString).range(
                of: "\(self.nbDriverRegistered)",
                range: NSRange(location: rankRange.lowerBound + 1, length: flatMessage.count - rankRange.upperBound)
            )
            participationAttributedString.setAttributes(numbersAttributes, range: participantsRange)
        } else if containsParticipants {
            participationAttributedString = flatMessage.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.secondaryColor).build()
            let participantsRange = (flatMessage  as NSString).range(of: "\(self.nbDriverRegistered)")
            participationAttributedString.setAttributes(numbersAttributes, range: participantsRange)
        } else {
            participationAttributedString = flatMessage.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.secondaryColor).build()
        }
        return participationAttributedString
    }
}
