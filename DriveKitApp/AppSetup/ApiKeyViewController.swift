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

    let viewModel = ApiKeyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        topLabel.textColor = DKUIColors.mainFontColor.color
        self.title = "welcome_header".keyLocalized()
        if viewModel.shouldDisplayErrorText() {
            bottomButton.configure(text: "button_see_documentation".keyLocalized(), style: .full)
            topLabel.text = "welcome_ko_title".keyLocalized()
            descriptionLabel.attributedText = viewModel.getApiKeyErrorAttibutedText()
        } else {
            bottomButton.configure(text: "welcome_ok_button".keyLocalized(), style: .full)
            topLabel.text = "welcome_ok_title".keyLocalized()
            descriptionLabel.attributedText = viewModel.getContentAttibutedText()
        }
    }

    @IBAction func buttonAction() {
        if viewModel.shouldDisplayErrorText() {
            if let docURL = URL(string: "https://github.com/DriveQuantPublic/drivekit-ui-ios") {
                UIApplication.shared.open(docURL)
            }
        } else {
            let userIdVC = UserIdViewController(nibName: "UserIdViewController", bundle: nil)
            self.navigationController?.pushViewController(userIdVC, animated: true)
        }
    }
}
