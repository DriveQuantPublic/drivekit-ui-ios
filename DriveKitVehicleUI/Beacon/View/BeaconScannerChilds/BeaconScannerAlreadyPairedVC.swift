// swiftlint:disable all
//
//  BeaconScannerFailureVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScannerAlreadyPairedVC: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let viewModel: BeaconViewModel
    
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconScannerAlreadyPairedVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButton()
        self.configureDescription()
    }
    
    private func configureButton() {
        cancelButton.configure(text: DKCommonLocalizable.cancel.text(), style: .full)
        confirmButton.configure(text: DKCommonLocalizable.confirm.text(), style: .full)
    }
    
    private func configureDescription() {
        let beaconCode = self.viewModel.beacon?.uniqueId?.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build() ?? NSMutableAttributedString(string: "")
        let vehicleName = self.viewModel.vehicleName.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build()
        let pairedVehicleName = self.viewModel.vehiclePaired?.computeName().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.mainFontColor).build() ?? NSMutableAttributedString(string: "")
        descriptionLabel.attributedText = "dk_vehicle_beacon_setup_replace_description".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).buildWithArgs(beaconCode, vehicleName, pairedVehicleName)
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        self.viewModel.showLoader()
        self.viewModel.replaceBeacon(completion: {status in
            DispatchQueue.main.async {
                self.viewModel.hideLoader()
                switch status {
                case .success:
                    self.viewModel.updateScanState(step: .congrats)
                case .error:
                    self.failedToPairedBeacon()
                case .unknownVehicle:
                    self.vehicleUnknown()
                case .unavailableBeacon:
                    self.viewModel.updateScanState(step: .beaconUnavailable)
                @unknown default:
                    break
                }
            }
        })
    }
    
    private func vehicleUnknown() {
        self.showAlertMessage(title: "", message: "dk_vehicle_unknown", back: true, cancel: false, completion: {
            self.viewModel.scanValidationFinished()
        })
    }
    
    private func failedToPairedBeacon() {
        self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_paired_beacon".dkVehicleLocalized(), back: false, cancel: false)
    }
}
