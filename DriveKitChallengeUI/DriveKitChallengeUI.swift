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
