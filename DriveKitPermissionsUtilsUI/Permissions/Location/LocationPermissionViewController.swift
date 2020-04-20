//
//  LocationPermissionViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 31/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class LocationPermissionViewController : PermissionViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingsContainer1: UIView!
    @IBOutlet weak var settingsDescription1: UILabel!
    @IBOutlet weak var settingsContainer2: UIView!
    @IBOutlet weak var settingsDescription2: UILabel!
    @IBOutlet weak var settingsContainer3: UIView!
    @IBOutlet weak var settingsDescription3: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    private let viewModel = LocationPermissionViewModel()


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
        self.titleLabel.attributedText = "dk_perm_utils_permissions_location_title".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightNormal).color(.mainFontColor).build()

        self.actionButton.configure(text: "dk_perm_utils_permissions_location_button_ios".dkPermissionsUtilsLocalized(), style: .full)

        if #available(iOS 13.0, *) {
            updateViewIOS13()
        } else {
            updateViewPreIOS13()
        }
    }

    private func updateViewIOS13() {
        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_location_ios13_ko".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer1.isHidden = false
        self.settingsDescription1.attributedText = "dk_perm_utils_permissions_phone_settings_location_step1".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer2.isHidden = false
        self.settingsDescription2.attributedText = "dk_perm_utils_permissions_phone_settings_location_step2".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer3.isHidden = false
        self.settingsDescription3.attributedText = "dk_perm_utils_permissions_phone_settings_location_step3".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }

    private func updateViewPreIOS13() {
        self.descriptionLabel.attributedText = "dk_perm_utils_permissions_location_pre_ios13_ko".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()

        self.settingsContainer1.isHidden = true
        self.settingsContainer2.isHidden = true
        self.settingsContainer3.isHidden = true
    }

}
