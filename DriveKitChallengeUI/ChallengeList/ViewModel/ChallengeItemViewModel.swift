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

struct ChallengeItemViewModel {
    let startDate: Date
    let endDate: Date
    let name: String
    let image: UIImage?

    init(challenge: DKChallenge) {
        startDate = challenge.startDate
        endDate = challenge.endDate
        name = challenge.title
        if let challengeImage = UIImage(named: String(format : "%d", challenge.iconCode), in: Bundle.challengeUIBundle, compatibleWith: nil) {
            image = challengeImage
        } else {
            image = UIImage(named: "101", in: Bundle.challengeUIBundle, compatibleWith: nil)
        }
    }

    static func formatStartAndEndDates(startDate: Date,
                                       endDate: Date,
                                       // TODO: move the color into constants or DKColors
                                       tintColor: UIColor = UIColor.init(hex: 0x9E9E9E),
                              alignment: NSTextAlignment = NSTextAlignment.left) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        return NSMutableAttributedString(string: "\(startDate.format(pattern: .standardDate)) - \(endDate.format(pattern: .standardDate))",
                                         attributes: [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14),
                         NSAttributedString.Key.foregroundColor: tintColor, NSAttributedString.Key.paragraphStyle : paragraphStyle])
    }
}
