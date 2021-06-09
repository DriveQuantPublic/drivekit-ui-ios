//
//  DriveKitChallengeUI.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 29/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitChallengeModule
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI

@objc public class DriveKitChallengeUI: NSObject {

    @objc public static let shared = DriveKitChallengeUI()

    @objc public func initialize() {
        DriveKitNavigationController.shared.challengeUI = self
    }

}

extension DriveKitChallengeUI: DriveKitChallengeUIEntryPoint {
    public func getChallengeListViewController() -> UIViewController {
        return ChallengeListVC()
    }

    public func getChallengeViewController(challengeId: String, completion: @escaping (UIViewController?) -> ()) {
        DriveKitChallenge.shared.getChallenge(challengeId: challengeId, type: .cache) { [weak self] status, challenge in
            if let challenge = challenge {
                if challenge.conditionsFilled, challenge.isRegistered {
                    DriveKitChallenge.shared.getChallengeDetail(challengeId: challengeId, completionHandler: { [weak self] status, challengeDetail in
                        DispatchQueue.main.async {
                            let challengeVC = self?.getViewControllerForChallenge(challenge: challenge, challengeDetail: challengeDetail)
                            completion(challengeVC)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        let challengeVC = self?.getViewControllerForChallenge(challenge: challenge)
                        completion(challengeVC)
                    }
                }
            } else {
                DriveKitChallenge.shared.getChallenge(challengeId: challengeId, type: .defaultSync) { [weak self] status, challenge in
                    if let challenge = challenge {
                        if challenge.conditionsFilled, challenge.isRegistered {
                            DriveKitChallenge.shared.getChallengeDetail(challengeId: challengeId, completionHandler: { [weak self] status, challengeDetail in
                                DispatchQueue.main.async {
                                    let challengeVC = self?.getViewControllerForChallenge(challenge: challenge, challengeDetail: challengeDetail)
                                    completion(challengeVC)
                                }
                            })
                        } else {
                            DispatchQueue.main.async {
                                let challengeVC = self?.getViewControllerForChallenge(challenge: challenge)
                                completion(challengeVC)
                            }
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    private func getViewControllerForChallenge(challenge: DKChallenge, challengeDetail: DKChallengeDetail? = nil) -> UIViewController {
        if let challengeDetail = challengeDetail, challenge.isRegistered, challenge.conditionsFilled {
            let challengeDetailsViewModel = ChallengeDetailViewModel(challenge: challenge, challengeDetail: challengeDetail)
            let challengeDetailsVC: ChallengeDetailVC = ChallengeDetailVC(viewModel: challengeDetailsViewModel)
            return challengeDetailsVC
        } else {
            let challengeParticipationViewModel = ChallengeParticipationViewModel(challenge: challenge)
            let challengeVC: ChallengeParticipationVC = ChallengeParticipationVC(viewModel: challengeParticipationViewModel)
            return challengeVC
        }
    }
}

extension Bundle {
    static let challengeUIBundle = Bundle(identifier: "com.drivequant.drivekit-challenge-ui")
}

extension String {
    public func dkChallengeLocalized() -> String {
        return self.dkLocalized(tableName: "DKChallengeLocalizable", bundle: Bundle.challengeUIBundle ?? .main)
    }
}
