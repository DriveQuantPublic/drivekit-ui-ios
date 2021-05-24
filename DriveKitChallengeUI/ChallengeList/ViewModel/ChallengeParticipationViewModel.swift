//
//  ChallengeParticipationViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI
import DriveKitChallengeModule

public enum ChallengeParticipationStatus: Int {
    case joined, failedToJoin, joining
}

public class ChallengeParticipationViewModel {
    private let challenge: DKChallenge
    private var joinedWithSuccess: Bool = false
    private let grayColor = UIColor(hex:0x9e9e9e)

    init(challenge: DKChallenge) {
        self.challenge = challenge
    }

    func getTitle() -> String {
        return challenge.title
    }

    func getTitleAttributedString() -> NSAttributedString {
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = .center
        let titleAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold), NSAttributedString.Key.foregroundColor: DKUIColors.mainFontColor.color, NSAttributedString.Key.paragraphStyle: alignment]
        let titleString = challenge.title
        var titleAttributedString = NSMutableAttributedString(string: titleString, attributes: titleAttributes)
        titleAttributedString = "%@\n\n\n%@".dkAttributedString().buildWithArgs(titleAttributedString, ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate, tintColor: grayColor, alignment: .center))
        return titleAttributedString
    }

    func getChallengeRulesAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16),
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: challenge.challengeDescription, attributes: attributes)
    }

    func getChallengeConditionsAttributedString() -> NSAttributedString? {
        if let conditionsDescription = challenge.conditionsDescription, !conditionsDescription.isCompletelyEmpty() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle]
            return NSAttributedString(string: conditionsDescription, attributes: attributes)
        } else {
            return nil
        }
    }

    func getSubscriptionAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 20).with(.traitBold),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: "dk_challenge_registered_confirmation".dkChallengeLocalized(), attributes: attributes)
    }

    func getCountDownAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16).with(.traitBold),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: "dk_challenge_start".dkChallengeLocalized(), attributes: attributes)
    }

    func getDisplayState() -> ChallengeParticipationDisplayState {
        if !challenge.isRegistered && !joinedWithSuccess {
            return .join
        } else if challenge.startDate.timeIntervalSinceNow > 0 {
            return .countDown
        } else {
            return .progress
        }
    }

    func haveLongRules() -> Bool {
        if let rules = challenge.rules, !rules.isCompletelyEmpty() {
            return true
        }
        return false
    }

    func getRulesViewModel() -> ChallengeRulesViewModel {
        return ChallengeRulesViewModel(challenge: challenge, participationViewModel: self, showButton: getDisplayState() == .join)
    }

    func joinChallenge(completionHandler: @escaping (ChallengeParticipationStatus) -> ()) {
        DriveKitChallenge.shared.joinChallenge(challengeId: challenge.id) { [weak self] status in
            switch status {
            case .alreadyJoined, .success:
                self?.joinedWithSuccess = true
                completionHandler(.joined)
            case .failedToJoin, .notFound:
                completionHandler(.failedToJoin)
            case .alreadyInProgress:
                completionHandler(.joining)
            }
        }
    }
}

public enum ChallengeParticipationDisplayState {
    case join, countDown, progress
}
