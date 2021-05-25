//
//  DriveKitChallengeUI.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 29/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitChallengeModule
import DriveKitDBChallengeAccessModule

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
                DispatchQueue.main.async {
                    let challnengeVC = self?.getViewControllerForChallenge(challenge: challenge)
                    completion(challnengeVC)
                }
            } else {
                DriveKitChallenge.shared.getChallenge(challengeId: challengeId, type: .defaultSync) { [weak self] status, challenge in
                    if let challenge = challenge {
                        DispatchQueue.main.async {
                            let challnengeVC = self?.getViewControllerForChallenge(challenge: challenge)
                            completion(challnengeVC)
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    private func getViewControllerForChallenge(challenge: DKChallenge) -> UIViewController {
        // TODO: handle other cases: ChallengeDetails
        let challengeParticipationViewModel = ChallengeParticipationViewModel(challenge: challenge)
        let challnengeVC: ChallengeParticipationVC = ChallengeParticipationVC(viewModel: challengeParticipationViewModel)
        return challnengeVC
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
