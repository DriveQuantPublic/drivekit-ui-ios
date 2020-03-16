//
//  BeaconFailureVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 11/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconScanFailureVC: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var retryImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: BeaconViewModel
    
    init(viewModel: BeaconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconScanFailureVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButton()
        descriptionLabel.attributedText = "dk_vehicle_beacon_scan_retry".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    private func configureButton() {
        backButton.backgroundColor = DKUIColors.secondaryColor.color
        backButton.setAttributedTitle(DKCommonLocalizable.cancel.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
        
        cancelButton.setAttributedTitle(DKCommonLocalizable.finish.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
        
        retryImageView.image = UIImage(named: "dk_beacon_retry", in: .vehicleUIBundle, compatibleWith: nil)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        retryImageView.isUserInteractionEnabled = true
        retryImageView.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        self.viewModel.updateScanState(step: .scan)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel.scanValidationFinished()
    }
}
