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
    private var completionHandler: ((Bool, RequestError?) -> Void)?

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "authentication_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }

    func getTitleAttributedText() -> NSAttributedString {
        let iconString = "ⓘ".dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.secondaryColor).build()
        let titleString = "authentication_title"
            .keyLocalized()
            .appending("  ")
            .dkAttributedString()
            .font(dkFont: .primary, style: .headLine1)
            .color(.mainFontColor)
            .buildWithArgs(iconString)
        return titleString
    }

    func sendUserId(userId: String, completionHandler: @escaping ((Bool, RequestError?) -> Void)) {
        DriveKitDelegateManager.shared.register(delegate: self)
        DriveKit.shared.setUserId(userId: userId)
        self.completionHandler = completionHandler
    }
}

extension UserIdViewModel: DriveKitDelegate {
    func driveKitDidConnect(_ driveKit: DriveKit) {
        DriveKitDelegateManager.shared.unregister(delegate: self)
        self.completionHandler?(true, nil)
        self.completionHandler = nil
    }

    func driveKitDidDisconnect(_ driveKit: DriveKit) {
        DriveKitDelegateManager.shared.unregister(delegate: self)
        self.completionHandler?(false, nil)
        self.completionHandler = nil
    }

    func driveKit(_ driveKit: DriveKit, didReceiveAuthenticationError error: RequestError) {
        DriveKitDelegateManager.shared.unregister(delegate: self)
        self.completionHandler?(false, error)
        self.completionHandler = nil
    }

    func userIdUpdateStatusChanged(status: UpdateUserIdStatus, userId: String?) {
        // Nothing to do.
    }
}
