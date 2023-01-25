// swiftlint:disable all
//
//  DriveKitChallengeUIEntryPoint.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 29/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public protocol DriveKitChallengeUIEntryPoint {
    func getChallengeListViewController() -> UIViewController
    func getChallengeViewController(challengeId: String, completion: @escaping  (UIViewController?) -> Void)
}
