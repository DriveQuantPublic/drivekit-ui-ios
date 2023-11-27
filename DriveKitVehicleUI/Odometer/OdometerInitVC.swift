// swiftlint:disable no_magic_numbers
//
//  OdometerInitVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 30/07/2019.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class OdometerInitVC: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var odometerImage: UIImageView!
    @IBOutlet private weak var odometerDesc: UILabel!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var odometerField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    private let viewModel: OdometerHistoryDetailViewModel

    init(viewModel: OdometerHistoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerInitVC.self), bundle: .vehicleUIBundle)
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
        let cancelButton = UIBarButtonItem(title: DKCommonLocalizable.cancel.text(), style: .plain, target: self, action: #selector(self.cancelSelector))
        cancelButton.tintColor = DKUIColors.navBarElementColor.color
        navigationItem.rightBarButtonItem = cancelButton
        validateButton.configure(title: DKCommonLocalizable.validate.text(), style: .full)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureHeaderOdometer() {
        self.odometerImage.image = DKVehicleImages.vehicleOdometer.image
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
        self.odometerField.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
        self.odometerField.keyboardType = .numberPad

        let odometerFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: 40))
        let button = UIButton.init(type: .system)
        button.setTitle(DKCommonLocalizable.ok.text(), for: .normal)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(validateOdometer(_:)))
        odometerFieldToolbar.items = [flexSpace, barButton]
        odometerFieldToolbar.sizeToFit()
        self.odometerField.inputAccessoryView = odometerFieldToolbar
    }

    @objc private func cancelSelector(sender: UIBarButtonItem) {
        close()
    }

    @IBAction private func didEndEditing(_ sender: Any) {
        _ = checkValue()
    }

    @IBAction private func validateOdometer(_ sender: Any) {
        self.odometerField.resignFirstResponder()
        if let text = self.odometerField.text, let value = Double(text) {
            if checkValue() {
                self.viewModel.updatedValue = value
                self.viewModel.validateHistory(viewController: self, showConfirmationAlert: false) { [weak self] in
                    self?.close()
                }
            }
        } else {
            self.warningField(error: DKCommonLocalizable.errorEmpty.text())
        }
    }

    private func checkValue() -> Bool {
        if let text = self.odometerField.text, let odometer = Double(text) {
            if odometer >= 0 && odometer < 1_000_000 {
                self.configureFieldOdometer()
                return true
            } else {
                self.warningField(error: "dk_vehicle_odometer_history_error".dkVehicleLocalized())
            }
        } else {
            self.warningField(error: "dk_vehicle_odometer_error_numeric".dkVehicleLocalized())
        }
        return false
    }

    private func warningField(error: String) {
        self.errorLabel.text = error
        self.errorLabel.textColor = DKUIColors.warningColor.color
        self.errorLabel.isHidden = false
    }

    private func close() {
        if let vehiclePickerNavigationController = self.navigationController as? DKVehiclePickerNavigationController {
            vehiclePickerNavigationController.endVehiclePicker()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard 
            let userInfo = notification.userInfo,
            let keyboardFrameBeginUserInfoKey = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        else { return }
        var keyboardFrame: CGRect = keyboardFrameBeginUserInfoKey.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 60
        self.scrollView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}
