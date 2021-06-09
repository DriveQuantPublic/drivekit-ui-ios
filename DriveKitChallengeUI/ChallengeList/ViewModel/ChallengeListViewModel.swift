//
//  ChallengeListViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 30/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitChallengeModule
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI
import UIKit

public protocol ChallengeListDelegate: AnyObject {
    func onChallengesAvailable()
    func didReceiveErrorFromService()
    func showAlert(_ alertController: UIAlertController)
    func showLoader()
    func hideLoader()
    func showViewController(_ viewController: UIViewController, animated: Bool)
}


public class ChallengeListViewModel {
    private var challenges: [DKChallenge] = []
    private(set) var currentChallenges: [ChallengeItemViewModel] = []
    private(set) var pastChallenges: [ChallengeItemViewModel] = []
    public weak var delegate: ChallengeListDelegate? = nil
    public private(set) var selectedTab: ChallengeListTab = .current

    func fetchChallenges() {
        delegate?.showLoader()
        DriveKitChallenge.shared.getChallenges { [weak self] status, challenges in
            DispatchQueue.main.async {
                if let self = self {
                    self.delegate?.hideLoader()
                    self.challenges = challenges
                    self.updateChallengeArrays()
                    self.delegate?.onChallengesAvailable()
                }
            }
        }
    }

    func updateChallengeArrays() {
        self.currentChallenges = self.challenges.currentChallenges().map({ challenge in
            return ChallengeItemViewModel(challenge: challenge)
        })
        self.pastChallenges = self.challenges.pastChallenges().map({ challenge in
            return ChallengeItemViewModel(challenge: challenge)
        })
    }

    func updateSelectedTab(challengeTab: ChallengeListTab) {
        selectedTab = challengeTab
    }
    func expectedCellHeight(challenge: ChallengeItemViewModel, viewWdth: CGFloat) -> CGFloat {
        let width = viewWdth - 124
        let attributedText: NSAttributedString = NSAttributedString(string: challenge.name, attributes: [.font: DKUIFonts.primary.fonts(size: 22).with(.traitBold)])
        let expectedRect = attributedText.boundingRect(with: CGSize(width: width, height: 600), options: .usesLineFragmentOrigin, context: nil)
        return max(124.0, expectedRect.height + 83)
    }

    func challengeViewModelSelected(challengeViewModel: ChallengeItemViewModel) {
        if challengeViewModel.finishedAndNotFilled {
            let alertTitle = Bundle.main.appName ?? ""
            let alert = UIAlertController(title: alertTitle, message: "dk_challenge_not_a_participant".dkChallengeLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
            self.delegate?.showAlert(alert)
        } else {
            delegate?.showLoader()
            DriveKitChallengeUI.shared.getChallengeViewController(challengeId: challengeViewModel.identifier) { [weak self] viewController in
                DispatchQueue.main.async {
                    self?.delegate?.hideLoader()
                    if let vc = viewController {
                        self?.delegate?.showViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
