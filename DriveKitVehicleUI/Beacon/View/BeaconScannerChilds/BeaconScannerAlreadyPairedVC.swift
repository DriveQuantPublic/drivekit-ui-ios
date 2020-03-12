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
    }
    
    private func configureButton() {
        cancelButton.backgroundColor = DKUIColors.secondaryColor.color
        cancelButton.setAttributedTitle(DKCommonLocalizable.cancel.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        
        confirmButton.backgroundColor = DKUIColors.secondaryColor.color
        confirmButton.setAttributedTitle(DKCommonLocalizable.confirm.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
    }
    
    private func configureDescription() {
        descriptionLabel.attributedText = "dk_vehicle_beacon_setup_replace_description".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        // TODO : replace beacon
    }
}
