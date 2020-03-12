//
//  BeaconScannerValidateVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScannerSuccessVC: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let viewModel : BeaconViewModel
    private let step : BeaconStep
    
    init(viewModel: BeaconViewModel, step: BeaconStep) {
        self.viewModel = viewModel
        self.step = step
        super.init(nibName: "BeaconScannerSuccessVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.attributedText = step.description.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        confirmButton.setAttributedTitle(step.confirmButtonText.dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        confirmButton.backgroundColor = DKUIColors.secondaryColor.color
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        if step == .success {
            self.viewModel.showLoader()
            self.viewModel.addBeaconToVehicle(completion: {status in
                DispatchQueue.main.async {
                    self.viewModel.hideLoader()
                    switch status {
                    case .success:
                        self.viewModel.updateScanState(step: .congrats)
                    case .error:
                        self.failedToPairedBeacon()
                    case .unknownBeacon, .invalidBeacon:
                        // Beacon is always known on this screen
                        break
                    case .unknownVehicle:
                        self.vehicleUnknown()
                    case .unavailableBeacon:
                        self.viewModel.updateScanState(step: .beaconUnavailable)
                    }
                }
            })
        } else {
            self.viewModel.scanValidationFinished()
        }
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
