// swiftlint:disable no_magic_numbers
//
//  DeleteAccountVC.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 12/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DeleteAccountVC: DKUIViewController {
    private let viewModel: DeleteAccountViewModel = DeleteAccountViewModel()
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "delete_account_header".keyLocalized()
        setupView()
    }

    func setupView() {
        self.deleteButton.setAttributedTitle(
            "button_delete_account"
                .keyLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .button)
                .color(.criticalColor)
                .uppercased()
                .build(),
            for: .normal
        )
        self.cancelButton.configure(title: DKCommonLocalizable.cancel.text(), style: .full)
        mainLabel.text = "account_deletion_content_1".keyLocalized()
        mainLabel.font = DKStyle(size: 14, traits: .traitBold).applyTo(font: .primary)
        mainLabel.textColor = DKUIColors.mainFontColor.color
        descriptionLabel.text = "account_deletion_content_2".keyLocalized()
        descriptionLabel.font = DKStyle(size: 14, traits: .none).applyTo(font: .primary)
        descriptionLabel.textColor = DKUIColors.mainFontColor.color

    }

    @IBAction func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteAccountAction() {
        let alert = UIAlertController(title: nil,
                                      message: "account_deletion_confirmation".keyLocalized(),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text().uppercased(), style: .destructive, handler: {[weak self] _ in
            self?.viewModel.deleteAccount { status in
                if status == .success {
                    self?.viewModel.logout()
                } else {
                    let errorMessage: String = (status == .forbidden) ? "account_deletion_error_forbidden".keyLocalized() : DKCommonLocalizable.error.text()
                    let errorAlert = UIAlertController(title: nil,
                                                       message: errorMessage,
                                                       preferredStyle: .alert)
                    let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    errorAlert.addAction(okAction)
                    self?.present(errorAlert, animated: true)
                }
            }
        })
        alert.addAction(deleteAction)

        self.present(alert, animated: true)
    }

}
