//
//  BeaconScannerInitVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScannerNotConfiguredVC: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: BeaconViewModel
    
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconScannerNotConfiguredVC", bundle: .vehicleUIBundle)
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
    }
    
    @IBAction func startClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
    
}
