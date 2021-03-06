//
//  VehiclePickerInputVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerInputVC : VehiclePickerStepView {
    
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputTextField: UIView!
    @IBOutlet weak var inputConfirmButton: UIButton!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!

    var textFieldView: DKTextField = DKTextField.viewFromNib

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
        if #available(iOS 11.0, *) {
            self.topConstraint.constant = 20
        } else {
            self.topConstraint.constant = 60
        }
        inputImageView.image = UIImage(named: "dk_vehicle_name_chooser",in: .vehicleUIBundle, compatibleWith: nil)
        inputTextLabel.attributedText = "dk_vehicle_name_chooser_description".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        inputConfirmButton.configure(text: DKCommonLocalizable.validate.text(), style: .full)
        self.configureTextField(placeholder: "dk_vehicle_name".dkVehicleLocalized())
    }

    func configureTextField(placeholder: String) {
        textFieldView.delegate = self
        textFieldView.target = view
        textFieldView.placeholder = placeholder
        textFieldView.title = placeholder
        textFieldView.enable = true
        textFieldView.keyBoardType = .asciiCapable
        if let name = viewModel.vehicleName {
            textFieldView.value = name
        } else {
             textFieldView.value = viewModel.getDefaultName()
        }
        inputTextField.embedSubview(textFieldView)
    }

    @IBAction func didConfirmInput(_ sender: Any) {
        self.showLoader()
        self.viewModel.vehicleName = textFieldView.getTextFieldValue()
        self.viewModel.addVehicle(completion: {status, vehicleId in
            DispatchQueue.main.async {
                self.hideLoader()
                switch status {
                case .success:
                    (self.navigationController as? DKVehiclePickerNavigationController)?.checkExtraStep(vehicleId: vehicleId!)
                case .unknownVehicle:
                    // We can't have this error, vehicle picker always return a known vehicle
                    break
                case .error:
                    self.showAlertMessage(title: "", message: "dk_vehicle_failed_to_retrieve_vehicle_data".dkVehicleLocalized(), back: false, cancel: false)
                @unknown default:
                    break
                }
            }
        })
    }

}

extension VehiclePickerInputVC : DKTextFieldDelegate {
    func userDidEndEditing(textField: DKTextField) {
        self.viewModel.vehicleName = textField.getTextFieldValue()
    }
}
