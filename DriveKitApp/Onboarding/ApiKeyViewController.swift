//
//  ApiKeyViewController.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 06/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ApiKeyViewController: UIViewController {
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomButton: UIButton!

    private let viewModel: ApiKeyViewModel

    init(viewModel: ApiKeyViewModel = ApiKeyViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ApiKeyViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        topLabel.textColor = DKUIColors.mainFontColor.color
        topLabel.font = DKStyles.headLine1.style.applyTo(font: .primary)
        self.title = "welcome_header".keyLocalized()
        if viewModel.shouldDisplayErrorText() {
            bottomButton.configure(text: "button_see_documentation".keyLocalized(), style: .full)
            topLabel.text = viewModel.getApiKeyErrorTitle()
            descriptionLabel.attributedText = viewModel.getApiKeyErrorAttibutedText()
        } else {
            bottomButton.configure(text: "welcome_ok_button".keyLocalized(), style: .full)
            topLabel.text = "welcome_ok_title".keyLocalized()
            descriptionLabel.attributedText = viewModel.getContentAttibutedText()
        }
    }

    @IBAction func buttonAction() {
        if viewModel.shouldDisplayErrorText() {
            if let docURL = URL(string: "drivekit_doc_ios_github_ui".keyLocalized()) {
                UIApplication.shared.open(docURL)
            }
        } else {
            let userIdVC = UserIdViewController(nibName: "UserIdViewController", bundle: nil)
            self.navigationController?.pushViewController(userIdVC, animated: true)
        }
    }
}
