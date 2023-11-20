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
    let finishedAndNotFilled: Bool

    init(challenge: DKChallenge) {
        identifier = challenge.id
        startDate = challenge.startDate
        endDate = challenge.endDate
        name = challenge.title
        if let challengeImage = DKChallengeImages.imageForTheme(iconCode: challenge.iconCode).image {
            image = challengeImage
        } else {
            image = DKChallengeImages.general101Trophy.image
        }
        if (challenge.isRegistered == false || challenge.conditionsFilled == false) && challenge.endDate.timeIntervalSinceNow < 0 {
            finishedAndNotFilled = true
        } else {
            finishedAndNotFilled = false
        }
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
}
