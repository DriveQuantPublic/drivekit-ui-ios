//
//  UserInfoViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 13/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitCommonUI

class UserInfoViewController: UIViewController {
    @IBOutlet private weak var containerScrollView: UIScrollView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var firstNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var pseudoTextField: CustomTextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    private var viewModel = UserInfoViewModel()

    init(viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: UserInfoViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        setupView()
    }

    func setupView() {
        self.title = "user_info_header".keyLocalized()
        sendButton.configure(text: "button_validation".keyLocalized(), style: .full)
        skipButton.configure(text: "button_next_step".keyLocalized(), style: .empty)
        topLabel.attributedText = viewModel.getTitleAttributedText()
        descriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        firstNameTextField.placeholder = "firstname".keyLocalized()
        firstNameTextField.autocorrectionType = .no
        lastNameTextField.placeholder = "lastname".keyLocalized()
        lastNameTextField.autocorrectionType = .no
        pseudoTextField.placeholder = "pseudo".keyLocalized()
        pseudoTextField.autocorrectionType = .no
        topLabel.isUserInteractionEnabled = true
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDocAction)))
        firstNameTextField.text = viewModel.getFirstName()
        lastNameTextField.text = viewModel.getLastName()
        pseudoTextField.text = viewModel.getPseudo()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        pseudoTextField.delegate = self
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        self.viewModel.resetDriveKit()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func openDocAction() {
        self.view.endEditing(false)
        self.containerScrollView.scrollRectToVisible(self.containerScrollView.frame, animated: true)
        if let docURL = URL(string: "drivekit_doc_ios_update_user_info".keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    @IBAction func updateUserInfoAction() {
        self.view.endEditing(false)
        self.containerScrollView.scrollRectToVisible(self.containerScrollView.frame, animated: true)
        if let firstName = firstNameTextField.text,
           let lastName = lastNameTextField.text,
           let pseudo = pseudoTextField.text {
                DispatchQueue.dispatchOnMainThread {
                    self.showLoader()
                }
                viewModel.updateUser(firstName: firstName, lastName: lastName, pseudo: pseudo) { [weak self] success in
                DispatchQueue.dispatchOnMainThread {
                    if success {
                        self?.goToNext()
                    } else {
                        self?.showAlertMessage(title: nil, message: "unknown_error".keyLocalized(), back: false, cancel: false)
                    }
                    self?.hideLoader()
                }
            }
        }
    }

    @IBAction func goToNext() {
        self.view.endEditing(false)
        self.containerScrollView.scrollRectToVisible(self.containerScrollView.frame, animated: true)

        if viewModel.shouldDisplayPermissions() {
            let permissionsVC = PermissionsViewController(nibName: "PermissionsViewController", bundle: nil)
            self.navigationController?.pushViewController(permissionsVC, animated: true)
        } else {
            viewModel.shouldDisplayVehicle() { [weak self] shouldDisplay in
                if shouldDisplay {
                    let vehiclesVC = VehiclesViewController(nibName: "VehiclesViewController", bundle: nil)
                    self?.navigationController?.pushViewController(vehiclesVC, animated: true)
                } else {
                    self?.navigationController?.setViewControllers([DashboardViewController()], animated: true)
                }
            }
        }
    }
}

extension UserInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let targetY = textField.frame.origin.y - 60
        let targetFrame = CGRect(x: containerScrollView.frame.origin.x,
                                 y: targetY,
                                 width: containerScrollView.frame.width,
                                 height: containerScrollView.frame.height)
        containerScrollView.scrollRectToVisible(targetFrame, animated: true)
    }
}
