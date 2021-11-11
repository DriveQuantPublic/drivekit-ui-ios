//
//  VehicleOdometerVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 30/07/2019.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehicleOdometerVC: DKUIViewController {
    @IBOutlet private weak var odometerImage: UIImageView!
    @IBOutlet private weak var odometerDesc: UILabel!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var odometerField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    private let viewModel: VehicleOdometerViewModel

    init(viewModel: VehicleOdometerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: VehicleOdometerVC.self), bundle: .vehicleUIBundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    private func configure() {
        self.title = "dk_vehicle_odometer_car".dkVehicleLocalized()
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        self.view.backgroundColor = .white
        configureHeaderOdometer()
        configureFieldOdometer()
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.setAttributedTitle(DKCommonLocalizable.cancel.text().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.white).build(), for: .normal)
        button.addTarget(self, action: #selector(cancelSelector), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        validateButton.configure(text: DKCommonLocalizable.validate.text(), style: .full)
    }

    private func configureHeaderOdometer() {
        self.odometerImage.image = UIImage(named: "dk_odometer", in: .vehicleUIBundle, compatibleWith: nil)
        self.odometerDesc.attributedText = "dk_vehicle_odometer_car_desc".dkVehicleLocalized().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.black).build()
    }

    private func configureFieldOdometer() {
        self.errorLabel.isHidden = true
        self.odometerField.backgroundColor = UIColor(hex: 0xfafafa)
        self.odometerField.borderStyle = .none
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: 2.0))
        self.odometerField.leftView = leftView
        self.odometerField.leftViewMode = .always
        self.odometerField.placeholder = "dk_vehicle_odometer_enter_mileage".dkVehicleLocalized()
        self.odometerField.keyboardType = .numberPad
    }

    @objc private func cancelSelector(sender: UIBarButtonItem) {
        close()
    }

    @IBAction private func didEndEditing(_ sender: Any) {
        if let text = self.odometerField.text, let odometer = Double(text) {
            if odometer >= 0 && odometer <= 1000000 {
                self.configureFieldOdometer()
            } else {
                self.warningField(error: "dk_vehicle_odometer_history_error".dkVehicleLocalized())
            }
        } else {
            self.warningField(error: "dk_vehicle_odometer_error_numeric".dkVehicleLocalized())
        }
    }

    @IBAction private func validateOdometer(_ sender: Any) {
        if let text = self.odometerField.text, let odometer = Double(text) {
            self.showLoader()
            self.viewModel.addOdometer(distance: odometer, completion: { [weak self] success, errorMessage in
                DispatchQueue.main.async {
                    if let self = self {
                        if success {
                            self.close()
                        } else {
                            self.hideLoader()
                            self.showAlertMessage(title: Bundle.main.appName ?? "", message: errorMessage, back: false, cancel: false, completion: nil)
                        }
                    }
                }
            })
        } else {
            self.warningField(error: DKCommonLocalizable.errorEmpty.text())
        }
    }

    private func warningField(error: String) {
        self.errorLabel.text = error
        self.errorLabel.textColor = DKUIColors.warningColor.color
        self.errorLabel.isHidden = false
    }

    private func close() {
        if let vehiclePickerNavigationController = self.navigationController as? DKVehiclePickerNavigationController {
            vehiclePickerNavigationController.checkExtraStep(vehicleId: self.viewModel.vehicleId)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

