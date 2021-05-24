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

        // TODO: replace this implementation by adding a function in DriveKitChallenge that returns a DKChallenge object from its Id (from database)
        DriveKitChallenge.shared.getChallenges { _, challenges in
            if let challenge = challenges.first(where: {$0.id == challengeId}) {
                // TODO: handle other cases: ChallengeDetails and popup
                let challengeParticipationViewModel = ChallengeParticipationViewModel(challenge: challenge)
                DispatchQueue.main.async {
                    let challnengeVC: ChallengeParticipationVC = ChallengeParticipationVC(viewModel: challengeParticipationViewModel)
                    completion(challnengeVC)
                }
            } else {
                completion(nil)
            }
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
