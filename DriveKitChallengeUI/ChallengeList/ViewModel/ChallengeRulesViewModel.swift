// swiftlint:disable no_magic_numbers
//
//  ChallengeRulesViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 21/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI
import DriveKitChallengeModule

public struct ChallengeRulesViewModel {
    private let challenge: DKChallenge
    public let showButton: Bool
    private let participationViewModel: ChallengeParticipationViewModel

    init(challenge: DKChallenge, participationViewModel: ChallengeParticipationViewModel, showButton: Bool) {
        self.challenge = challenge
        self.showButton = showButton
        self.participationViewModel = participationViewModel
    }

    func getFullRulesAttributedString() -> NSAttributedString? {
        if let data = challenge.rules?.data(using: .utf8) {
            let attributedString = try? NSMutableAttributedString(data: data,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html,
                                                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                                                  documentAttributes: nil)
            attributedString?.replaceFont(with: DKUIFonts.primary.fonts(size: 16))
            return attributedString
        }
        return nil
    }

    func getOptinText() -> String {
        return challenge.optinText ?? ""
    }

    func joinChallenge(completionHandler: @escaping (ChallengeParticipationStatus) -> Void) {
        participationViewModel.joinChallenge { status in
            completionHandler(status)
        }
    }
}
