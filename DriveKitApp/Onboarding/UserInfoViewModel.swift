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
import DriveKitVehicleModule

class UserInfoViewModel {
    private var userInfo: UserInfo?

    init(userInfo: UserInfo? = nil) {
        self.userInfo = userInfo
    }

    func updateUser(firstName: String, lastName: String, pseudo: String, completion: @escaping (Bool) -> Void) {
        DriveKit.shared.updateUserInfo(firstname: firstName, lastname: lastName, pseudo: pseudo) { success in
            if success {
                self.userInfo = UserInfo(firstname: firstName, lastname: lastName, pseudo: pseudo)
            }
            completion(success)
        }
    }

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "user_info_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }

    func getTitleAttributedText() -> NSAttributedString {
        let iconString = "ⓘ".dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.secondaryColor).build()
        let titleString = "user_info_title".keyLocalized().appending("  ").dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).buildWithArgs(iconString)
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

    func shouldDisplayPermissions() -> Bool {
        var missingPermissionsCount: Int = 0
        if DKDiagnosisHelper.shared.getPermissionStatus(.location) != .valid {
            missingPermissionsCount = missingPermissionsCount + 1
        }
        if DKDiagnosisHelper.shared.getPermissionStatus(.activity) != .valid {
            missingPermissionsCount = missingPermissionsCount + 1
        }
        return missingPermissionsCount > 0
    }

    func shouldDisplayVehicle(completion: @escaping (Bool) -> Void) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: .cache) { _, vehicles in
            DispatchQueue.dispatchOnMainThread {
                completion(vehicles.count == 0)
            }
        }
    }

    func logout() {
        DriveKitConfig.logout()
    }
}
