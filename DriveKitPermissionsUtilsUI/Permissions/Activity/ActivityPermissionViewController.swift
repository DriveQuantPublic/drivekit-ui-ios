//
//  ActivityPermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class ActivityPermissionViewController : PermissionViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    private let viewModel = ActivityPermissionViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.titleLabel.attributedText = "dk_perm_utils_permissions_phone_settings_activity_title".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.mainFontColor).build()

        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_phone_settings_activity_text".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.actionButton.configure(text: "dk_perm_utils_permissions_activity_button_ios".dkPermissionsUtilsLocalized(), style: .full)
    }

}


extension ActivityPermissionViewController : ActivityPermissionView {

}
