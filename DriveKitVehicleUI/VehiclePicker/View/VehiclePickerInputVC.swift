//
//  VehiclePickerInputVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerInputVC: VehiclePickerStepView {
    
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputErrorLabel: UILabel!
    @IBOutlet weak var inputConfirmButton: UIButton!
    
    let viewModel : VehiclePickerViewModel
    
    init (viewModel: VehiclePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: VehiclePickerInputVC.self), bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.delegate = self
        self.setup()
    }
    
    func setup() {
        if self.viewModel.currentStep == .name {
            inputImageView.image = UIImage(named: "dk_vehicle_name_chooser")
            inputTextLabel.attributedText = "dk_vehicle_name_chooser_description".dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
            inputConfirmButton.setAttributedTitle("dk_validate".dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build(), for: .normal)
            inputConfirmButton.backgroundColor = DKUIColors.secondaryColor.color
            self.configureTextField(placeholder: "dk_vehicle_name".dkVehicleLocalized())
        }
    }
    
    func configureTextField(placeholder: String) {
        self.inputErrorLabel.isHidden = true
        self.inputTextField.borderStyle = .none
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: 2.0))
        self.inputTextField.leftView = leftView
        self.inputTextField.leftViewMode = .always
        self.inputTextField.placeholder = placeholder
        self.inputTextField.keyboardType = .asciiCapable
        self.inputTextField.returnKeyType = .done
        if let name = viewModel.vehicleName {
            self.inputTextField.text = name
        } else {
            //self.inputTextField.text =  viewModel.defaultName
        }
    }
    
    func warningField(error: String) {
        self.inputErrorLabel.text = error
        self.inputErrorLabel.textColor = UIColor.orange
        self.inputErrorLabel.isHidden = false
    }
    
    @IBAction func didEndEditing(_ sender: Any) {
        if self.viewModel.currentStep == .name {
            if self.inputTextField.text == nil {
                self.warningField(error: "dk_empty_vehicle_name")
            } else {
                self.viewModel.vehicleName = self.inputTextField.text
                self.configureTextField(placeholder: "dk_vehicle_name")
            }
        }
    }
    
    @IBAction func didConfirmInput(_ sender: Any) {
        self.showLoader()
        self.viewModel.addVehicle(completion: {status in
            DispatchQueue.main.async {
                self.hideLoader()
                switch status {
                case .success:
                    self.navigationController?.dismiss(animated: true, completion: nil)
                case .unknownVehicle:
                    self.showAlertMessage(title: "", message: "Unknown vehicle index", back: false, cancel: false)
                case .error:
                    self.showAlertMessage(title: "", message: "Failed to create vehicle, please retry later", back: false, cancel: false)
                }
            }
        })
    }
}

extension VehiclePickerInputVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
