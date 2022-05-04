//
//  SettingsViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 04/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitCoreModule

class SettingsViewModel {
    private var userInfo: UserInfo?

    init() {
        updateUserInfo()
    }

    func getUserId() -> String {
        return DriveKit.shared.config.getUserId() ?? ""
    }

    func getUserFirstname(orPlaceholder allowPlaceholder: Bool = true) -> String {
        if let firstname = self.userInfo?.firstname, !firstname.isCompletelyEmpty() {
            return firstname
        } else if allowPlaceholder {
            return "parameters_enter_firstname".keyLocalized()
        } else {
            return ""
        }
    }

    func updateUserFirstname(_ firstname: String, completion: @escaping (Bool) -> ()) {
        DriveKit.shared.updateUserInfo(firstname: firstname, lastname: nil, pseudo: nil) { [weak self] success in
            self?.updateUserInfo()
            completion(success)
        }
    }

    func getUserLastname(orPlaceholder allowPlaceholder: Bool = true) -> String {
        if let lastname = self.userInfo?.lastname, !lastname.isCompletelyEmpty() {
            return lastname
        } else if allowPlaceholder {
            return "parameters_enter_lastname".keyLocalized()
        } else {
            return ""
        }
    }

    func updateUserLastname(_ lastname: String, completion: @escaping (Bool) -> ()) {
        DriveKit.shared.updateUserInfo(firstname: nil, lastname: lastname, pseudo: nil) { [weak self] success in
            self?.updateUserInfo()
            completion(success)
        }
    }

    func getUserPseudo(orPlaceholder allowPlaceholder: Bool = true) -> String {
        if let pseudo = self.userInfo?.pseudo, !pseudo.isCompletelyEmpty() {
            return pseudo
        } else if allowPlaceholder {
            return "parameters_enter_pseudo".keyLocalized()
        } else {
            return ""
        }
    }

    func updateUserPseudo(_ pseudo: String, completion: @escaping (Bool) -> ()) {
        DriveKit.shared.updateUserInfo(firstname: nil, lastname: nil, pseudo: pseudo) { [weak self] success in
            self?.updateUserInfo()
            completion(success)
        }
    }

    func getAutoStartDescriptionKey() -> String {
        if isTripAnalysisAutoStartEnabled() {
            return "parameters_auto_start_enabled"
        } else {
            return "parameters_auto_start_disabled"
        }
    }

    func isTripAnalysisAutoStartEnabled() -> Bool {
        return DriveKitConfig.isTripAnalysisAutoStartEnabled()
    }

    func enableAutoStart(_ enable: Bool) {
        DriveKitConfig.enableTripAnalysisAutoStart(enable)
    }

    func logout() {
        DriveKitConfig.reset()
        if let appDelegate = UIApplication.shared.delegate, let appNavigationController = appDelegate.window??.rootViewController as? AppNavigationController {
            appNavigationController.setViewControllers([ApiKeyViewController()], animated: true)
        }
    }

    private func updateUserInfo() {
        DriveKit.shared.getUserInfo(synchronizationType: .cache) { [weak self] _ , userInfo in
            self?.userInfo = userInfo
        }
    }
}
