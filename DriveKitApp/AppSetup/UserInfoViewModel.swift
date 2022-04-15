//
//  UserInfoViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 13/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitCommonUI

class UserInfoViewModel {
    private var userInfo: UserInfo?
    private let grayColor = UIColor(hex:0x9e9e9e)

    init(userInfo: UserInfo? = nil) {
        self.userInfo = userInfo
    }

    func updateUser(firstName: String, lastName: String, pseudo: String, completion: @escaping (Bool) -> ()) {
        DriveKit.shared.updateUserInfo(firstname: firstName, lastname: lastName, pseudo: pseudo) { success in
            if success {
                self.userInfo = UserInfo(firstname: firstName, lastname: lastName, pseudo: pseudo)
            }
            completion(success)
        }
    }

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "user_info_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(grayColor).build()
    }

    func getTitleAttributedText() -> NSAttributedString {
        let iconString = "ⓘ".dkAttributedString().font(dkFont: .primary, style: .bigtext).color(DKUIColors.secondaryColor.color).build()
        let titleString = "user_info_title".keyLocalized().appending("  ").dkAttributedString().font(dkFont: .primary, style: .bigtext).color(DKUIColors.mainFontColor.color).buildWithArgs(iconString)
        return titleString
    }

    func getFirstName() -> String? {
        return userInfo?.firstname
    }

    func getLastName() -> String? {
        return userInfo?.lastname
    }

    func getPseudo() -> String? {
        return userInfo?.pseudo
    }
}
