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
    @IBOutlet private weak var batteryOptimizationDescription: UILabel!
    @IBOutlet private weak var batteryOptimizationButton: UILabel!
    @IBOutlet private weak var batteryOptimizationTouch: UIButton!
    @IBOutlet private weak var contactContainer: UIView!
    @IBOutlet private weak var contactTitle: UILabel!
    @IBOutlet private weak var contactDescription: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    @IBOutlet private weak var loggingContainer: UIView!
    @IBOutlet private weak var loggingTitle: UILabel!
    @IBOutlet private weak var loggingDescription: UILabel!
    @IBOutlet private weak var loggingButton: UISwitch!
    @IBOutlet private var loggingDescriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var loggingButtonBottomConstraint: NSLayoutConstraint!

    private var viewModel: DiagnosisViewModel

    init() {
        self.viewModel = DiagnosisViewModel()
        super.init(nibName: "DiagnosisViewController", bundle: Bundle.permissionsUtilsUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "dk_perm_utils_app_diag_title".dkPermissionsUtilsLocalized()
        self.viewModel.view = self
        self.updateUI()

        self.batteryOptimizationTouch.setBackgroundImage(UIImage(color: UIColor.pu_selectionColor), for: .highlighted)
    }

    private func updateUI() {
        self.updateSensorsUI()
        self.updateBatteryOptimizationUI()
        self.updateContactUI()
        self.updateLoggingUI()
    }


    @IBAction private func batteryOptimizationDidTouch() {
        self.viewModel.batteryOptimizationViewModel.performAction()
    }

    @IBAction private func contactSupport() {
        if let contactViewModel = self.viewModel.contactViewModel {
            contactViewModel.contactSupport()
        }
    }

    @IBAction private func loggingStateDidChange() {
        self.viewModel.setLoggingEnabled(self.loggingButton.isOn)
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

    func updateBatteryOptimizationUI() {
        self.batteryOptimizationTitle.attributedText = self.viewModel.batteryOptimizationViewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
        self.batteryOptimizationDescription.attributedText = self.viewModel.batteryOptimizationViewModel.description.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
        if let action = self.viewModel.batteryOptimizationViewModel.action {
            self.batteryOptimizationButton.attributedText = action.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).build()
            self.batteryOptimizationTouch.isEnabled = true
            self.loggingDescriptionBottomConstraint.isActive = false
            self.loggingButtonBottomConstraint.isActive = true
            self.batteryOptimizationButton.isHidden = false
        } else {
            self.batteryOptimizationTouch.isEnabled = false
            self.loggingDescriptionBottomConstraint.isActive = true
            self.loggingButtonBottomConstraint.isActive = false
            self.batteryOptimizationButton.isHidden = true
        }
    }

    func updateContactUI() {
        if let contactViewModel = self.viewModel.contactViewModel {
            self.contactTitle.attributedText = contactViewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            self.contactDescription.attributedText = contactViewModel.description.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
            self.contactButton.configure(text: contactViewModel.buttonTitle, style: .full)
            self.contactContainer.isHidden = false
        } else {
            self.contactContainer.isHidden = true
        }
    }

    func updateLoggingUI() {
        if let loggingViewModel = self.viewModel.loggingViewModel {
            self.loggingTitle.attributedText = loggingViewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            self.loggingDescription.attributedText = loggingViewModel.description.dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
            self.loggingButton.isOn = loggingViewModel.isLoggingEnabled
            self.loggingButton.onTintColor = DKUIColors.secondaryColor.color
            self.loggingContainer.isHidden = false
        } else {
            self.loggingContainer.isHidden = true
        }
    }

}
