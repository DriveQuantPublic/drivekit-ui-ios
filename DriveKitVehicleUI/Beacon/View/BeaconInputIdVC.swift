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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private let viewModel : BeaconViewModel
    private let parentView : UIViewController
    
    public init(viewModel: BeaconViewModel, parentView: UIViewController) {
        self.viewModel = viewModel
        self.parentView = parentView
        super.init(nibName: "BeaconInputIdVC", bundle: .vehicleUIBundle)
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
        button.isEnabled = false
        button.backgroundColor = DKUIColors.secondaryColor.color
        button.setAttributedTitle(DKCommonLocalizable.validate.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).uppercased().build(), for: .normal)
    }
    
    private func configureTextField() {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: 2.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.backgroundColor = DKUIColors.neutralColor.color
        textField.borderStyle = .none
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .done
        textField.placeholder = "dk_vehicle_beacon_setup_code_hint".dkVehicleLocalized()
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    @IBAction func checkBeaconCode(_ sender: Any) {
        if let code = textField.text, !code.isEmpty {
            self.showLoader()
            self.viewModel.checkCode(code: code, completion: {status in
                DispatchQueue.main.async {
                    self.hideLoader()
                    switch status {
                    case .success:
                        self.navigationController?.pushViewController(BeaconScannerVC(viewModel: self.viewModel, step: .scan, parentView: self.parentView), animated: true)
                        break
                    case .error, .unknownVehicle :
                        self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_retrieve_beacon".dkVehicleLocalized(), back: false, cancel: false)
                    case .unknownBeacon:
                        self.showAlertMessage(title: "", message: String.init(format: "dk_vehicle_beacon_setup_code_unknown_id".dkVehicleLocalized(), self.viewModel
                        .beacon?.code ?? ""), back: false, cancel: false)
                    case .invalidBeacon:
                        self.showAlertMessage(title: "", message: String.init(format: "dk_vehicle_beacon_setup_code_invalid_id".dkVehicleLocalized(), self.viewModel
                        .beacon?.code ?? ""), back: false, cancel: false)
                    case.unavailableBeacon:
                        self.showAlertMessage(title: "", message: "dk_vehicle_beacon_setup_code_unavailable_id".dkVehicleLocalized(), back: false, cancel: false)
                    }
                }
            })
        }
    }
}

extension BeaconInputIdVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            button.isEnabled = true
        }else{
            button.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
