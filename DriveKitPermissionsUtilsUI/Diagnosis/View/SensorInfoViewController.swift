// swiftlint:disable no_magic_numbers
//
//  SensorInfoViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SensorInfoViewController: UIViewController {

    private let viewModel: SensorInfoViewModel
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    private var appeared = false

    init(viewModel: SensorInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SensorInfoViewController", bundle: Bundle.permissionsUtilsUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.layer.cornerRadius = 10
        self.contentView.backgroundColor = DKUIColors.backgroundView.color
        self.titleContainer.backgroundColor = DKUIColors.primaryColor.color
        self.actionButton.titleLabel?.numberOfLines = 0
        self.actionButton.titleLabel?.textAlignment = .center

        self.titleLabel.attributedText = self.viewModel.title.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(DKUIColors.fontColorOnPrimaryColor).build()
        self.descriptionLabel.attributedText = self.viewModel.description.dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.mainFontColor).build()
        self.actionButton.configure(title: self.viewModel.buttonTitle, style: .empty)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !self.appeared {
            let originalTransform = self.contentView.transform
            let translateTransform = originalTransform.translatedBy(x: 0, y: 100)
            self.contentView.transform = translateTransform
            UIView.animate(withDuration: 0.2) {
                self.contentView.transform = originalTransform
            }
            self.appeared = true
        }
    }

    @IBAction private func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func manageAction() {
        self.viewModel.manageAction()
        self.dismiss(animated: true, completion: nil)
    }

}
