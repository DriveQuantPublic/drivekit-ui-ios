//
//  UserIdViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 11/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule

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
        sendButton.configure(title: "button_validation".keyLocalized(), style: .full)
        topLabel.attributedText = viewModel.getTitleAttributedText()
        descriptionLabel.attributedText = viewModel.getDescriptionAttibutedText()
        textField.placeholder = "authentication_unique_identifier".keyLocalized()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        topLabel.isUserInteractionEnabled = true
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDocAction)))
    }

    @IBAction func sendAction() {
        textField.resignFirstResponder()
        if let userId = textField.text, !userId.isEmpty {
            showLoader()
            viewModel.sendUserId(userId: userId) { [weak self] success, error in
                DispatchQueue.dispatchOnMainThread {
                    if success {
                        self?.showLoader(message: "sync_user_info_loading_message".keyLocalized())
                        SynchroServicesManager.syncModules(
                            [.userInfo, .vehicle, .workingHours, .trips],
                            stepCompletion: { [weak self] _, remainingServices in
                                if let service = remainingServices.first {
                                    switch service {
                                        case .vehicle:
                                            self?.showLoader(message: "sync_vehicles_loading_message".keyLocalized())
                                        case .workingHours:
                                            self?.showLoader(message: "sync_working_hours_loading_message".keyLocalized())
                                        case .trips:
                                            self?.showLoader(message: "sync_trips_loading_message".keyLocalized())
                                        default:
                                            break
                                    }
                                }
                            },
                            completion: { statuses in
                                self?.hideLoader()
                                let infoSyncStatus = (!statuses.isEmpty) ? statuses[0] == .success : true
                                self?.goToUserInfoVC(syncStatus: infoSyncStatus)
                            })
                    } else {
                        self?.hideLoader()
                        if let error = error {
                            if error == .unauthenticated {
                                let apiVM = ApiKeyViewModel(invalidApiKeyErrorReceived: true)
                                let apiVC = ApiKeyViewController(viewModel: apiVM)
                                self?.navigationController?.setViewControllers([apiVC], animated: true)
                            } else {
                                self?.showAlertMessage(title: nil, message: error.getErrorMessage(), back: false, cancel: false)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func openDocAction() {
        if let docURL = URL(string: "drivekit_doc_ios_user_id".keyLocalized()) {
            UIApplication.shared.open(docURL)
        }
    }

    func goToUserInfoVC(syncStatus: Bool = true) {
        DispatchQueue.dispatchOnMainThread {
            self.showLoader()
        }
        DriveKit.shared.getUserInfo(synchronizationType: syncStatus ? .cache : .defaultSync) { [weak self] _, userInfo in
            DispatchQueue.dispatchOnMainThread {
                let userInfoViewModel = UserInfoViewModel(userInfo: userInfo)
                let userInfoVC = UserInfoViewController(viewModel: userInfoViewModel)
                self?.navigationController?.pushViewController(userInfoVC, animated: true)
                self?.hideLoader()
            }
        }
    }
}
