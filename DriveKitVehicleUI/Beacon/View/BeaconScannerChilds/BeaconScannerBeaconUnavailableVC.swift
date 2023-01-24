//
//  BeaconScannerUnavailableVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScannerBeaconUnavailableVC: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: BeaconViewModel
    
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconScannerBeaconUnavailableVC", bundle: .vehicleUIBundle)
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
        cancelButton.configure(text: DKCommonLocalizable.cancel.text(), style: .empty)
        retryButton.configure(text: DKCommonLocalizable.confirm.text(), style: .full)
    }
    
    private func configureDescription() {
        descriptionLabel.attributedText = "dk_vehicle_beacon_setup_code_retry_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    @IBAction func retryClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
}
