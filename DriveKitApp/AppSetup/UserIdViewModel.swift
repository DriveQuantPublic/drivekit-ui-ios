//
//  UserIdViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

class UserIdViewModel {
    private var completionHandler: ((Bool) -> ())?
    private let grayColor = UIColor(hex:0x9e9e9e)

    func sendUserId(userId: String, completionHandler: @escaping ((Bool) -> ())) {
        DriveKit.shared.setUserId(userId: userId)
        self.completionHandler = completionHandler
    }
}

extension UserIdViewModel: DriveKitDelegate {
    func driveKitDidConnect(_ driveKit: DriveKit) {
        self.completionHandler?(true)
        self.completionHandler = nil
    }

    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        self.completionHandler?(false)
        self.completionHandler = nil
    }

    func driveKitDidReceiveAuthenticationError(_ driveKit: DriveKit) {
        self.completionHandler?(false)
        self.completionHandler = nil
    }
}
