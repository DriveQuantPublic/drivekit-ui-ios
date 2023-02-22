// swiftlint:disable all
//
//  ChallengeRulesVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeRulesVC: DKUIViewController {

    private let viewModel: ChallengeRulesViewModel?
    @IBOutlet private weak var rulesTextView: UITextView?
    @IBOutlet private weak var acceptButton: UIButton?

    public init(viewModel: ChallengeRulesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeRulesVC.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "dk_challenge_rule_title".dkChallengeLocalized()
        rulesTextView?.attributedText = self.viewModel?.getFullRulesAttributedString()
        setupAcceptButton()
    }

    func setupAcceptButton() {
        if let viewModel = viewModel, viewModel.showButton {
            acceptButton?.configure(style: .full)
            acceptButton?.setTitle("dk_challenge_optin_title".dkChallengeLocalized(), for: .normal)
            acceptButton?.titleLabel?.font = DKUIFonts.primary.fonts(size: 20).with(.traitBold)
        } else {
            acceptButton?.isHidden = true
        }
    }

    @IBAction func acceptButtonTapped() {
        let alert = UIAlertController(title: "dk_challenge_optin_title".dkChallengeLocalized(), message: self.viewModel?.getOptinText(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { [weak self] _ in
            self?.showLoader()
            self?.viewModel?.joinChallenge { [weak self] status in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    if status == .joined {
                        self?.navigationController?.popViewController(animated: true)
                    } else if status == .failedToJoin {
                        self?.showAlertMessage(title: nil, message: "dk_challenge_failed_to_join".dkChallengeLocalized(), back: false, cancel: false)
                    }
                }
            }

        }))

        self.present(alert, animated: true, completion: nil)
    }
}
