//
//  BeaconInputIdVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 10/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class BeaconInputIdVC: DKUIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UIView!
    
    private let viewModel : BeaconViewModel
    private let parentView : UIViewController
    private let filterView = DKTextField.viewFromNib
    
    public init(viewModel: BeaconViewModel, parentView: UIViewController) {
        self.viewModel = viewModel
        self.parentView = parentView
        super.init(nibName: "BeaconInputIdVC", bundle: .vehicleUIBundle)
        self.title = "dk_beacon_paired_title".dkVehicleLocalized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureTextField()
    }
    
    private func configureView() {
        titleLabel.attributedText = "dk_vehicle_beacon_setup_code_title".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        button.backgroundColor = DKUIColors.secondaryColor.color
        button.setAttributedTitle(DKCommonLocalizable.validate.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
    }
    
    private func configureTextField() {
        filterView.delegate = self
        filterView.placeholder = "dk_vehicle_beacon_setup_code_hint".dkVehicleLocalized()
        filterView.title = "dk_vehicle_beacon_setup_code_hint".dkVehicleLocalized()
        filterView.keyBoardType = .asciiCapable
        filterView.enable = true
        textField.embedSubview(filterView)
    }
    
    @IBAction func checkBeaconCode(_ sender: Any) {
        if let code = filterView.getTextFieldValue(), !code.isEmpty {
            self.showLoader()
            self.viewModel.checkCode(code: code, completion: {status in
                DispatchQueue.main.async {
                    self.hideLoader()
                    switch status {
                    case .success:
                        self.navigationController?.pushViewController(BeaconScannerVC(viewModel: self.viewModel, step: .scan, parentView: self.parentView), animated: true)
                        break
                    case .error :
                        self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_retrieve_beacon".dkVehicleLocalized(), back: false, cancel: false)
                    case .unknownBeacon:
                        self.showAlertMessage(title: "", message: "dk_vehicle_beacon_setup_code_unavailable_id".dkVehicleLocalized(), back: false, cancel: false)
                    }
                }
            })
        }
    }
}

extension BeaconInputIdVC : DKTextFieldDelegate {
    func userDidEndEditing(textField: DKTextField) {
        return
    }
}
