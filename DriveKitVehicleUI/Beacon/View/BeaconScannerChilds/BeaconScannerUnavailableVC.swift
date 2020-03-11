//
//  BeaconScannerUnavailableVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScannerUnavailableVC: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: BeaconViewModel
    
    init(viewModel: BeaconViewModel){
        self.viewModel = viewModel
        super.init(nibName: "BeaconScannerUnavailableVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButton()
    }
    
    private func configureButton() {
        cancelButton.setAttributedTitle(DKCommonLocalizable.cancel.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
        
        retryButton.backgroundColor = DKUIColors.secondaryColor.color
        retryButton.setAttributedTitle(DKCommonLocalizable.confirm.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
    }
    
    private func configureDescription() {
        
    }
    
    @IBAction func retryClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
}
