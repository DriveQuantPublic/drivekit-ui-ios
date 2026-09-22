//
//  LocationPermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class LocationPermissionViewController: PermissionViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingsContainer1: UIView!
    @IBOutlet weak var settingsDescription1: UILabel!
    @IBOutlet weak var settingsContainer2: UIView!
    @IBOutlet weak var settingsDescription2: UILabel!
    @IBOutlet weak var settingsContainer3: UIView!
    @IBOutlet weak var settingsDescription3: UILabel!
    @IBOutlet weak var settingsContainer4: UIView!
    @IBOutlet weak var settingsDescription4: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    private let viewModel = LocationPermissionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topImageView.image = DKPermissionsUtilsImages.backgroundLocationPermission.image

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
        self.titleLabel.attributedText = "dk_perm_utils_permissions_location_title"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .highlightNormal)
            .color(.mainFontColor)
            .build()

        self.actionButton.configure(title: "dk_perm_utils_permissions_location_button_ios".dkPermissionsUtilsLocalized(), style: .full)

        updateViewIOS14()
    }

    private func updateViewIOS14() {
        self.settingsContainer1.isHidden = false
        self.settingsDescription1.attributedText = "dk_perm_utils_permissions_phone_settings_location_step1"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()

        self.settingsContainer2.isHidden = false
        self.settingsDescription2.attributedText = "dk_perm_utils_permissions_phone_settings_location_step2"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()

        self.settingsContainer3.isHidden = false
        self.settingsDescription3.attributedText = "dk_perm_utils_permissions_phone_settings_location_step3"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()

        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_location_ios14_ko"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()

        self.settingsContainer4.isHidden = false
        self.settingsDescription4.attributedText = "dk_perm_utils_permissions_phone_settings_location_step4"
            .dkPermissionsUtilsLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()
    }
}
