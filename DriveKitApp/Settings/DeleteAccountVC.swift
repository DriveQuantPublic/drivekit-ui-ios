//
//  DeleteAccountVC.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 12/01/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class DeleteAccountVC: UIViewController {
    private let viewModel: DeleteAccountViewModel = DeleteAccountViewModel()
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "delete_account_header".keyLocalized()
        setupView()
    }

    func setupView() {
        self.deleteButton.setAttributedTitle("button_delete_account".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .button).color(.criticalColor).uppercased().build(), for: .normal)
        self.cancelButton.configure(text: DKCommonLocalizable.cancel.text(), style: .full)
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
        let okAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: {action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: DKCommonLocalizable.delete.text().uppercased(), style: .destructive, handler: {[weak self] action in
            self?.viewModel.deleteAccount { status in
                if status == .success {
                    self?.viewModel.logout()
                } else {
                    let errorMessage: String = (status == .forbidden) ? "account_deletion_error_forbidden".keyLocalized() : DKCommonLocalizable.error.text()
                    let errorAlert = UIAlertController(title: nil,
                                                  message: errorMessage,
                                                       preferredStyle: .alert)
                    errorAlert.addAction(okAction)
                    self?.present(errorAlert, animated: true)
                }
            }
        })
        alert.addAction(deleteAction)

        self.present(alert, animated: true)
    }

}