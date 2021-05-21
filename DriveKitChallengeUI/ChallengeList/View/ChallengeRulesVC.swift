//
//  ChallengeRulesVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeRulesVC: UIViewController {

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
}
