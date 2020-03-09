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
    
    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerInputVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        inputImageView.image = UIImage(named: "dk_vehicle_name_chooser",in: .vehicleUIBundle, compatibleWith: nil)
        inputTextLabel.attributedText = "dk_vehicle_name_chooser_description".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        inputConfirmButton.setAttributedTitle(DKCommonLocalizable.validate.text().dkAttributedString().font(dkFont: .primary, style: .button).color(.fontColorOnSecondaryColor).build(), for: .normal)
        inputConfirmButton.backgroundColor = DKUIColors.secondaryColor.color
        self.configureTextField(placeholder: "dk_vehicle_name".dkVehicleLocalized())
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
        self.inputTextField.backgroundColor = DKUIColors.neutralColor.color
        if let name = viewModel.vehicleName {
            self.inputTextField.text = name
        } else {
            self.inputTextField.becomeFirstResponder()
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
