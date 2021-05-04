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
    public private(set) var challenges: [DKChallenge] = []
    public weak var delegate: ChallengeListDelegate? = nil
    
    func fetchChallenges() {
        DriveKitChallenge.shared.getChallenges { status, challenges in
            DispatchQueue.main.async {
                self.challenges = challenges
                self.delegate?.onChallengesAvailable()
            }
        }
    }
}
