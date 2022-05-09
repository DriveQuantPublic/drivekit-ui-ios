//
//  SettingsViewController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 03/05/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()

    @IBOutlet private weak var logoutButton: UIButton!
    // UserAccount.
    @IBOutlet private weak var userAccountIcon: UIImageView!
    @IBOutlet private weak var userAccountTitle: UILabel!
    @IBOutlet private weak var userAccountDescription: UILabel!
    @IBOutlet private weak var userAccount_userIdTitle: UILabel!
    @IBOutlet private weak var userAccount_userIdValue: UIButton!
    @IBOutlet private weak var userAccount_firstnameTitle: UILabel!
    @IBOutlet private weak var userAccount_firstnameValue: UIButton!
    @IBOutlet private weak var userAccount_lastnameTitle: UILabel!
    @IBOutlet private weak var userAccount_lastnameValue: UIButton!
    @IBOutlet private weak var userAccount_pseudoTitle: UILabel!
    @IBOutlet private weak var userAccount_pseudoValue: UIButton!
    // AutoStart.
    @IBOutlet private weak var autoStartIcon: UIImageView!
    @IBOutlet private weak var autoStartTitle: UILabel!
    @IBOutlet private weak var autoStartDescription: UILabel!
    @IBOutlet private weak var autoStartSwitch: UISwitch!
    // Notifications.
    @IBOutlet private weak var notificationsIcon: UIImageView!
    @IBOutlet private weak var notificationsTitle: UILabel!
    @IBOutlet private weak var notificationsDescription: UILabel!
    @IBOutlet private weak var notificationsButton: UIButton!
    // Separators.
    @IBOutlet private var separators: [UIView]!

    init() {
        super.init(nibName: String(describing: SettingsViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        setupView()
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupView() {
        self.title = "parameters_header".keyLocalized()
        self.notificationsButton.setAttributedTitle("see_settings".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).uppercased().build(), for: .normal)
        self.logoutButton.setAttributedTitle("button_logout".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.criticalColor).uppercased().build(), for: .normal)
        configureIcon(self.userAccountIcon)
        configureIcon(self.autoStartIcon)
        configureIcon(self.notificationsIcon)
        configureTitle(self.userAccountTitle, key: "parameters_account_title")
        configureTitle(self.autoStartTitle, key: "parameters_auto_start_title")
        configureTitle(self.notificationsTitle, key: "parameters_notification_title")
        configureDescription(self.userAccountDescription, key: "parameters_account_description")
        configureDescription(self.notificationsDescription, key: "parameters_notification_description")
        configureUserAccountTitle(self.userAccount_userIdTitle, key: "userId")
        configureUserAccountTitle(self.userAccount_firstnameTitle, key: "firstname")
        configureUserAccountTitle(self.userAccount_lastnameTitle, key: "lastname")
        configureUserAccountTitle(self.userAccount_pseudoTitle, key: "pseudo")
        configureUserAccountValue(self.userAccount_userIdValue, value: self.viewModel.getUserId(), enabled: false)
        self.autoStartSwitch.onTintColor = DKUIColors.secondaryColor.color
        self.autoStartSwitch.isOn = self.viewModel.isTripAnalysisAutoStartEnabled()
        for separator in separators {
            separator.backgroundColor = DKUIColors.neutralColor.color
        }
        updateUI()
    }

    private func updateUI() {
        configureUserAccountValue(self.userAccount_firstnameValue, value: self.viewModel.getUserFirstname(), placeholder: "parameters_enter_firstname".keyLocalized())
        configureUserAccountValue(self.userAccount_lastnameValue, value: self.viewModel.getUserLastname(), placeholder: "parameters_enter_lastname".keyLocalized())
        configureUserAccountValue(self.userAccount_pseudoValue, value: self.viewModel.getUserPseudo(), placeholder: "parameters_enter_pseudo".keyLocalized())
        configureDescription(self.autoStartDescription, key: self.viewModel.getAutoStartDescriptionKey(), warning: !self.viewModel.isTripAnalysisAutoStartEnabled())
    }

    private func configureIcon(_ icon: UIImageView) {
        icon.tintColor = DKUIColors.mainFontColor.color
    }

    private func configureTitle(_ titleLabel: UILabel, key: String) {
        titleLabel.textColor = DKUIColors.mainFontColor.color
        titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        titleLabel.text = key.keyLocalized()
    }

    private func configureDescription(_ descriptionLabel: UILabel, key: String, warning: Bool = false) {
        descriptionLabel.textColor = warning ? DKUIColors.warningColor.color : DKUIColors.complementaryFontColor.color
        descriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        descriptionLabel.text = key.keyLocalized()
    }

    private func configureUserAccountTitle(_ label: UILabel, key: String) {
        label.textColor = DKUIColors.mainFontColor.color
        label.font = DKStyles.headLine2.withSizeDelta(-2).applyTo(font: .primary)
        label.text = key.keyLocalized()
    }

    private func configureUserAccountValue(_ button: UIButton, value: String?, placeholder: String? = nil, enabled: Bool = true) {
        let color: DKUIColors
        let emptyValue = value?.isCompletelyEmpty() ?? true
        if !emptyValue {
            color = enabled ? .secondaryColor : .complementaryFontColor
        } else {
            color = .warningColor
        }
        let displayValue: String
        if let value = value, !emptyValue {
            displayValue = value
        } else {
            displayValue = placeholder ?? "-"
        }
        button.setAttributedTitle(displayValue.dkAttributedString().font(dkFont: .primary, style: .smallText).color(color).build(), for: .normal)
        button.isEnabled = enabled
    }

    @IBAction private func logout() {
        self.showAlertMessage(title: nil, message: "logout_confirmation".keyLocalized(), back: false, cancel: true) {
            self.viewModel.logout()
        }
    }

    @IBAction private func editFirstname() {
        showEditAlert(title: "parameters_enter_firstname".keyLocalized(), currentValue: self.viewModel.getUserFirstname()) { [weak self] newFirstname in
            if let self = self {
                if self.viewModel.getUserFirstname() != newFirstname {
                    self.showLoader()
                    self.viewModel.updateUserFirstname(newFirstname) { [weak self] success in
                        self?.userInfoDidEdit(success: success)
                    }
                }
            }
        }
    }

    @IBAction private func editLastname() {
        showEditAlert(title: "parameters_enter_lastname".keyLocalized(), currentValue: self.viewModel.getUserLastname()) { [weak self] newLastname in
            if let self = self {
                if self.viewModel.getUserLastname() != newLastname {
                    self.showLoader()
                    self.viewModel.updateUserLastname(newLastname) { [weak self] success in
                        self?.userInfoDidEdit(success: success)
                    }
                }
            }
        }
    }

    @IBAction private func editPseudo() {
        showEditAlert(title: "parameters_enter_pseudo".keyLocalized(), currentValue: self.viewModel.getUserPseudo()) { [weak self] newPseudo in
            if let self = self {
                if self.viewModel.getUserPseudo() != newPseudo {
                    self.showLoader()
                    self.viewModel.updateUserPseudo(newPseudo) { [weak self] success in
                        self?.userInfoDidEdit(success: success)
                    }
                }
            }
        }
    }

    private func userInfoDidEdit(success: Bool) {
        DispatchQueue.dispatchOnMainThread {
            self.hideLoader()
            if success {
                self.updateUI()
            } else {
                self.showAlertMessage(title: "client_error".keyLocalized(), message: nil, back: false, cancel: false)
            }
        }
    }

    private func showEditAlert(title: String, currentValue: String?, completion: @escaping (String) -> ()) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = UIKeyboardType.default
            textField.text = currentValue
        }
        let validateAction = UIAlertAction(title: DKCommonLocalizable.validate.text(), style: .default) { [weak alert] _ in
            if let alert = alert, let textField = alert.textFields?.first, let newValue = textField.text {
                completion(newValue)
            }
        }
        alert.addAction(validateAction)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    @IBAction private func autoStartSwitchDidChange() {
        self.viewModel.enableAutoStart(self.autoStartSwitch.isOn)
        updateUI()
    }

    @IBAction private func openNotificationSettings() {
        self.navigationController?.pushViewController(NotificationSettingsViewController(), animated: true)
    }
}
