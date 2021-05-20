//
//  ChalllengeParticipationViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI

public struct ChalllengeParticipationViewModel {
    private var challenge: DKChallenge
    private let grayColor = UIColor(hex:0x9e9e9e)

    init(challenge: DKChallenge) {
        self.challenge = challenge
    }

    func getTitle() -> String {
        return challenge.title
    }

    func getTitleAttributedSting() -> NSAttributedString {
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = .center
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color, NSAttributedString.Key.paragraphStyle: alignment]
        let titleString = challenge.title
        var titleAttributedString = NSMutableAttributedString(string: titleString, attributes: titleAttributes)
        titleAttributedString = "%@\n\n\n%@".dkAttributedString().buildWithArgs(titleAttributedString, ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate, tintColor: grayColor, alignment: .center))
//        titleAttributedString = titleAttributedString + "\n\n\n" + ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate, tintColor: grayColor, alignment: .center)
        return titleAttributedString
    }

    func getDisplayState() -> ChallengeParticipationDisplayState {
        // TODO: complete implementation
        return .join
    }
}

public enum ChallengeParticipationDisplayState {
    case join, countDown, progress
}
