//
//  DiagnosisViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 16/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class DiagnosisViewController : DKUIViewController {

    @IBOutlet private weak var globalStatus: GlobalStateView!
    @IBOutlet private weak var locationStatus: SensorStateView!
    @IBOutlet private weak var notificationStatus: SensorStateView!
    @IBOutlet private weak var connectionStatus: SensorStateView!
    @IBOutlet private weak var activityStatus: SensorStateView!
    @IBOutlet private weak var bluetoothStatus: SensorStateView!
    @IBOutlet private weak var batteryOptimizationTitle: UILabel!
    @IBOutlet private weak var batteryOptimizationDescriptionPart1: UILabel!
    @IBOutlet private weak var batteryOptimizationDescriptionPart2: UILabel!
    @IBOutlet private weak var batteryOptimizationTouch: UIButton!
    @IBOutlet private weak var contactContainer: UIView!
    @IBOutlet private weak var contactTitle: UILabel!
    @IBOutlet private weak var contactDescription: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    @IBOutlet private weak var loggingContainer: UIView!
    @IBOutlet private weak var loggingTitle: UILabel!
    @IBOutlet private weak var loggingDescription: UILabel!
    @IBOutlet private weak var loggingButton: UISwitch!

    private var viewModel: DiagnosisViewModel

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = DiagnosisViewModel()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.view = self
        self.updateUI()

        self.batteryOptimizationTitle.attributedText = "dk_perm_utils_app_diag_battery_title".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
        self.batteryOptimizationDescriptionPart1.attributedText = "dk_perm_utils_app_diag_battery_text_ios_01".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        let batteryOptimizationDescriptionPart2_part1 = "dk_perm_utils_app_diag_battery_text_ios_02".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        let batteryOptimizationDescriptionPart2_part2 = "dk_perm_utils_app_diag_battery_link_ios".dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).build()
        self.batteryOptimizationDescriptionPart2.attributedText = "%@ %@".dkAttributedString().buildWithArgs(batteryOptimizationDescriptionPart2_part1 ,batteryOptimizationDescriptionPart2_part2)
        self.batteryOptimizationTouch.setBackgroundImage(UIImage(color: UIColor(white: 0.5, alpha: 0.5)), for: .highlighted)
    }

    private func updateUI() {
        self.updateSensorsUI()
        self.updateContactUI()
        self.updateLoggingUI()
    }

}

extension DiagnosisViewController : DiagnosisView {

    func updateSensorsUI() {
        self.globalStatus.viewModel = self.viewModel.globalStatusViewModel
        self.locationStatus.viewModel = self.viewModel.locationStatusViewModel
        self.notificationStatus.viewModel = self.viewModel.notificationStatusViewModel
        self.connectionStatus.viewModel = self.viewModel.connectionStatusViewModel
        self.activityStatus.viewModel = self.viewModel.activityStatusViewModel
        self.bluetoothStatus.viewModel = self.viewModel.bluetoothStatusViewModel
    }

    func updateContactUI() {
        if let contactViewModel = self.viewModel.contactViewModel {
            self.contactTitle.attributedText = contactViewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            self.contactDescription.attributedText = contactViewModel.description.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
            self.contactButton.configure(text: contactViewModel.buttonTitle, style: .full)
            self.contactContainer.isHidden = false
        } else {
            self.contactContainer.isHidden = true
        }
    }

    func updateLoggingUI() {
        if let loggingViewModel = self.viewModel.loggingViewModel {
            self.loggingTitle.attributedText = loggingViewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            self.loggingDescription.attributedText = loggingViewModel.description.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
            self.loggingButton.isOn = loggingViewModel.isLoggingEnabled
            self.loggingButton.onTintColor = DKUIColors.secondaryColor.color
            self.loggingContainer.isHidden = false
        } else {
            self.loggingContainer.isHidden = true
        }
    }

}
