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
        } /*else {
            self.inputTextField.becomeFirstResponder()
        }*/
        self.inputTextField.delegate = self
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
                    // We can have this error, vehicle picker always return a known vehicle
                    break
                case .error:
                    self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_retrieve_vehicle_data".dkVehicleLocalized(), back: false, cancel: false)
                }
            }
        })
    }
    
}

extension VehiclePickerInputVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
        if let text = textField.text, !text.isEmpty {
            inputConfirmButton.isEnabled = true
        }else{
            inputConfirmButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
