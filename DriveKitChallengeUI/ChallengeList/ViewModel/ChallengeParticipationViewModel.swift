// swiftlint:disable all
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
import UIKit

public enum ChallengeParticipationStatus: Int {
    case joined, failedToJoin, joining
}

public class ChallengeParticipationViewModel {
    private let challenge: DKChallenge
    private var joinedWithSuccess: Bool = false
    private let conditionsArray: [String: ChallengeConditionProgressViewModel]
    private let isRulesTab: Bool

    init(challenge: DKChallenge, isRulesTab: Bool = false) {
        self.challenge = challenge
        self.conditionsArray = ChallengeConditionProgressViewModel.getConditionsViewModel(conditions: challenge.conditions, driverConditions: challenge.driverConditions)
        self.isRulesTab = isRulesTab
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
        titleAttributedString = "%@\n\n\n%@".dkAttributedString().buildWithArgs(titleAttributedString, ChallengeItemViewModel.formatStartAndEndDates(startDate: challenge.startDate, endDate: challenge.endDate, tintColor: DKUIColors.complementaryFontColor.color, alignment: .center))
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

    func getConditionsHeaderAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSAttributedString(string: "dk_challenge_unranked_conditions_info".dkChallengeLocalized(), attributes: attributes)
    }
    func getCountDownAttributedString() -> NSAttributedString {
        let attString = NSMutableAttributedString()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let challengeStartString: String = "dk_challenge_start".dkChallengeLocalized() + "\n"
        attString.append(NSAttributedString(string: challengeStartString, attributes: attributes))
        let text = getTimeAttributedString()
        attString.append(text)
        return attString
    }

    func getDisplayState() -> ChallengeParticipationDisplayState {
        if isRulesTab {
            return .rulesTab
        } else if !challenge.isRegistered && !joinedWithSuccess {
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

    func joinChallenge(completionHandler: @escaping (ChallengeParticipationStatus) -> Void) {
        DriveKitChallenge.shared.joinChallenge(challengeId: challenge.id) { [weak self] status in
            switch status {
            case .alreadyJoined, .success:
                self?.joinedWithSuccess = true
                completionHandler(.joined)
            case .failedToJoin, .notFound:
                completionHandler(.failedToJoin)
            case .alreadyInProgress:
                completionHandler(.joining)
            @unknown default:
                completionHandler(.failedToJoin)
            }
        }
    }

    func getTimeAttributedString() -> NSAttributedString {
        let calendar = Calendar.current
        let calendarComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: Date(), to: challenge.startDate)
        guard let day = calendarComponents.day,
              let hour = calendarComponents.hour,
              let minute = calendarComponents.minute,
              let second = calendarComponents.second
              else {
            return NSAttributedString()
        }
        let components = [day, hour, minute, second]
        let days = String.localizedStringWithFormat(DKCommonLocalizable.unitDay.text(), components[0])
        let hours = String.localizedStringWithFormat(DKCommonLocalizable.unitHour.text(), components[1])
        let minutes = String.localizedStringWithFormat(DKCommonLocalizable.unitMinute.text(), components[2])
        let seconds = String.localizedStringWithFormat(DKCommonLocalizable.unitSecond.text(), components[3])

        let units = [days, hours, minutes, seconds]

        let firstNonZeroIndex = components.firstIndex { $0 > 0 }

        guard let first = firstNonZeroIndex else {
            return NSAttributedString()
        }

        let filteredComponents = components[first...]
        let unitsOffset = units.count - filteredComponents.count

        let firstFont = DKUIFonts.primary.fonts(size: 22).with(.traitBold)
        let secondFont = DKUIFonts.primary.fonts(size: 16)

        let baseLineOffset = (firstFont.xHeight - secondFont.xHeight) / 2

        let countdownAttributedString = NSMutableAttributedString()
        for (index, component) in filteredComponents.enumerated() {

            let value = NSAttributedString(string: String(component) + " ",
                                           attributes: [NSAttributedString.Key.font: firstFont])
            countdownAttributedString.append(value)
            let unit = NSAttributedString(string: units[index + unitsOffset] + "  ",
                                          attributes: [NSAttributedString.Key.font: secondFont,
                                                       NSAttributedString.Key.baselineOffset: baseLineOffset])
            countdownAttributedString.append(unit)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        countdownAttributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: countdownAttributedString.length))
        return countdownAttributedString
    }

    func getConditionsCount() -> Int {
        return conditionsArray.keys.count
    }

    func getConditionViewModel(index: Int) -> ChallengeConditionProgressViewModel? {
        let keysArray = conditionsArray.keys.sorted { $0 > $1 }
        if index < keysArray.count {
            return conditionsArray[keysArray[index]]
        } else {
            return nil
        }
    }

    func getConditionsProgressTableHeight() -> CGFloat {
        return 80 * CGFloat(conditionsArray.keys.count)
    }
}

public enum ChallengeParticipationDisplayState {
    case join, countDown, progress, rulesTab
}
