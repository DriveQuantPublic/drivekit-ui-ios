//
//  ChallengeListViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 30/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitChallengeModule
import DriveKitDBChallengeAccessModule
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
    public private(set) var currentChallenges: [DKChallenge] = []
    public private(set) var pastChallenges: [DKChallenge] = []
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
        self.currentChallenges = self.challenges.currentChallenges()
        self.pastChallenges = self.challenges.pastChallenges()
    }

    func updateSelectedTab(challengeTab: ChallengeListTab) {
        selectedTab = challengeTab
    }
}
