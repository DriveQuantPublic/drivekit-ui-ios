//
//  NotificationsPermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by Amine Gahbiche on 17/05/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import UIKit

class NotificationsPermissionViewController: PermissionViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    private let viewModel = NotificationsPermissionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topImageView.image = DKPermissionsUtilsImages.notificationsPermission.image

        self.viewModel.view = self
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.checkState()
    }

    @IBAction func openSettings() {
        self.viewModel.openSettings()
    }

    private func updateView() {
        self.titleLabel.attributedText = "dk_perm_utils_app_diag_notification_title"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .highlightNormal)
            .color(.mainFontColor)
            .build()

        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_notifications_text1"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()

        self.actionButton.configure(title: "dk_perm_utils_permissions_phone_settings_notifications_button".dkPermissionsUtilsLocalized(), style: .full)
    }

}
