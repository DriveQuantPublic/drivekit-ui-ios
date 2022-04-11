//
//  UserIdViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

class UserIdViewModel {
    private var completionHandler: ((Bool) -> ())?
    private let grayColor = UIColor(hex:0x9e9e9e)

    func getDescriptionAttibutedText() -> NSAttributedString {
        let contentAttributes = [NSAttributedString.Key.font: DKUIFonts.primary.fonts(size: 14), NSAttributedString.Key.foregroundColor: grayColor]
        let contentString = "authentication_description".keyLocalized()
        return NSAttributedString(string: contentString, attributes: contentAttributes)
    }

    func sendUserId(userId: String, completionHandler: @escaping ((Bool) -> ())) {
        DriveKitDelegateController.shared.registerDelegate(delegate: self)
        DriveKit.shared.setUserId(userId: userId)
        self.completionHandler = completionHandler
    }
}

extension UserIdViewModel: DriveKitDelegate {
    func driveKitDidConnect(_ driveKit: DriveKit) {
        DriveKitDelegateController.shared.unregisterDelegate(delegate: self)
        self.completionHandler?(true)
        self.completionHandler = nil
    }

    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        DriveKitDelegateController.shared.unregisterDelegate(delegate: self)
        self.completionHandler?(false)
        self.completionHandler = nil
    }

    func driveKitDidReceiveAuthenticationError(_ driveKit: DriveKit) {
        DriveKitDelegateController.shared.unregisterDelegate(delegate: self)
        self.completionHandler?(false)
        self.completionHandler = nil
    }
}
