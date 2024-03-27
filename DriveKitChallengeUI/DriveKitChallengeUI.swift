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
import UIKit

@objc public class DriveKitChallengeUI: NSObject {
    static let tag = "DriveKit Challenge UI"

    @objc public static let shared = DriveKitChallengeUI()
    private var challengeListVC: ChallengeListVC?
    
    @objc public func initialize() {
        DriveKitLog.shared.infoLog(tag: DriveKitChallengeUI.tag, message: "Initialization")
    }

    private override init() {
        super.init()
        DriveKitChallenge.shared.addListener(listener: self)
        DriveKitNavigationController.shared.challengeUI = self
    }

    deinit {
        DriveKitChallenge.shared.removeListener(listener: self)
    }
}

extension DriveKitChallengeUI: DriveKitChallengeUIEntryPoint {
    public func getChallengeListViewController() -> UIViewController {
        let challengeListVC = ChallengeListVC()
        self.challengeListVC = challengeListVC
        return challengeListVC
    }

    public func getChallengeViewController(challengeId: String, completion: @escaping (UIViewController?) -> Void) {
        DriveKitChallenge.shared.getChallenge(challengeId: challengeId, type: .cache) { [weak self] _, challenge in
            if let challenge = challenge {
                if challenge.conditionsFilled, challenge.isRegistered {
                    DriveKitChallenge.shared.getChallengeDetail(challengeId: challengeId, type: .cache) { [weak self] _, challengeDetail in
                        if let challengeDetail = challengeDetail {
                            DispatchQueue.main.async {
                                let challengeVC = self?.getViewControllerForChallenge(challenge: challenge, challengeDetail: challengeDetail, needUpdate: true)
                                completion(challengeVC)
                            }
                        } else {
                            // try to fetch Challenge detail from server
                            DriveKitChallenge.shared.getChallengeDetail(challengeId: challengeId, completionHandler: { [weak self] _, challengeDetail in
                                DispatchQueue.main.async {
                                    let challengeVC = self?.getViewControllerForChallenge(challenge: challenge, challengeDetail: challengeDetail)
                                    completion(challengeVC)
                                }
                            })
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let challengeVC = self?.getViewControllerForChallenge(challenge: challenge)
                        completion(challengeVC)
                    }
                }
            } else {
                DriveKitChallenge.shared.getChallenge(challengeId: challengeId, type: .defaultSync) { [weak self] _, challenge in
                    if let challenge = challenge {
                        if challenge.conditionsFilled, challenge.isRegistered {
                            DriveKitChallenge.shared.getChallengeDetail(challengeId: challengeId, completionHandler: { [weak self] _, challengeDetail in
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
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    private func getViewControllerForChallenge(challenge: DKChallenge, challengeDetail: DKChallengeDetail? = nil, needUpdate: Bool = false) -> UIViewController {
        if let challengeDetail = challengeDetail, challenge.isRegistered, challenge.conditionsFilled {
            let challengeDetailsViewModel = ChallengeDetailViewModel(challenge: challenge, challengeDetail: challengeDetail)
            let challengeDetailsVC: ChallengeDetailVC = ChallengeDetailVC(viewModel: challengeDetailsViewModel)
            challengeDetailsVC.needUpdate = true
            return challengeDetailsVC
        } else {
            let challengeParticipationViewModel = ChallengeParticipationViewModel(challenge: challenge)
            let challengeVC: ChallengeParticipationVC = ChallengeParticipationVC(viewModel: challengeParticipationViewModel)
            return challengeVC
        }
    }
}

extension DriveKitChallengeUI: DriveKitChallengeListener {
    public func challengesUpdated() {
        self.challengeListVC?.refresh()
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

@objc(DKUIChallengeInitializer)
class DKUIChallengeInitializer: NSObject {
    @objc static func initUI() {
        DriveKitChallengeUI.shared.initialize()
    }
}
