//
//  UserIdViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class UserIdViewController: UIViewController {
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var textField: CustomTextField!
    @IBOutlet private weak var sendButton: UIButton!
    private var viewModel = UserIdViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.title = "authentication_header".keyLocalized()
        self.navigationItem.hidesBackButton = true
        sendButton.configure(text: "button_validation".keyLocalized(), style: .full)
        topLabel.text = "authentication_title".keyLocalized()
        descriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        topLabel.textColor = DKUIColors.mainFontColor.color
        textField.placeholder = "authentication_unique_identifier".keyLocalized()
        textField.autocorrectionType = .no
    }

    @IBAction func sendAction() {
        textField.resignFirstResponder()
        if let userId = textField.text, !userId.isEmpty {
            showLoader()
            viewModel.sendUserId(userId: userId) { [weak self] success in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    if success {
                        self?.showLoader(message: "sync_user_info_loading_message".keyLocalized())
                        SynchroServicesManager.syncModules([.userInfo, .vehicle, .workingHours, .trips], stepCompletion:  { [weak self] status, remainingServices in
                            self?.hideLoader()
                            if let service = remainingServices.first {
                                switch service {
                                case .userInfo:
                                    break
                                case .vehicle:
                                    self?.showLoader(message: "sync_vehicles_loading_message".keyLocalized())
                                case .workingHours:
                                    self?.showLoader(message: "sync_working_hours_loading_message".keyLocalized())
                                case .trips:
                                    self?.showLoader(message: "sync_trips_loading_message".keyLocalized())
                                case .badge:
                                    break
                                case .challenge:
                                    break
                                }
                            }
                        }) { statuses in
                            // TODO: if success, open next view
                        }
                    } else {
                        // TODO: display error message "authentication_error"?
                    }
                }
            }

        }
    }
}
