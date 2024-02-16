// swiftlint:disable no_magic_numbers
//
//  UserPseudoViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 02/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule

public class UserPseudoViewController: UIViewController {
    public typealias UserPseudoCompletion = (_ success: Bool) -> Void

    public var completion: UserPseudoCompletion?
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var pseudoInput: UITextField!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var errorLabelHeightConstraint: NSLayoutConstraint!
    private var appeared = false

    public init(completion: UserPseudoCompletion? = nil) {
        self.completion = completion
        super.init(nibName: "UserPseudoViewController", bundle: Bundle.driveKitCommonUIBundle)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.contentView.backgroundColor = .white

        self.errorLabelHeightConstraint.constant = 0
        self.errorLabel.attributedText = DKCommonLocalizable.error.text().dkAttributedString().font(dkFont: .primary, style: .smallText).color(DKUIColors.warningColor).build()

        if let appName = Bundle.main.appName {
            self.titleLabel.attributedText = appName
                .dkAttributedString()
                .font(dkFont: .primary, style: .headLine1)
                .color(DKUIColors.mainFontColor)
                .build()
        }
        self.descriptionLabel.attributedText = DKCommonLocalizable.noPseudo.text()
            .dkAttributedString()
            .font(dkFont: .primary, style: .smallText)
            .color(DKUIColors.mainFontColor)
            .build()
        self.validateButton.setAttributedTitle(DKCommonLocalizable.validate.text().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).build(), for: .normal)
        self.cancelButton.setAttributedTitle(DKCommonLocalizable.later.text().dkAttributedString().font(dkFont: .primary, style: .normalText).build(), for: .normal)

        self.pseudoInput.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
        self.pseudoInput.placeholder = DKCommonLocalizable.pseudo.text()
        self.pseudoInput.delegate = self

        self.loadingView.isHidden = false
        DriveKit.shared.getUserInfo(synchronizationType: .cache) { [weak self] _, userInfo in
            DispatchQueue.main.async {
                if let self = self {
                    if let pseudo = userInfo?.pseudo, self.isPseudoValid(pseudo) {
                        if let completion = self.completion {
                            completion(true)
                        }
                    } else {
                        DriveKit.shared.getUserInfo(synchronizationType: .defaultSync) { [weak self] _, userInfo in
                            DispatchQueue.main.async {
                                if let self = self {
                                    if let pseudo = userInfo?.pseudo, self.isPseudoValid(pseudo) {
                                        if let completion = self.completion {
                                            completion(true)
                                        }
                                    } else {
                                        self.loadingView.isHidden = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
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

    @IBAction private func validate() {
        if let pseudo = self.pseudoInput.text, isPseudoValid(pseudo) {
            self.loadingView.isHidden = false
            self.errorLabelHeightConstraint.constant = 0
            DriveKit.shared.updateUserInfo(pseudo: pseudo) { [weak self] success in
                DispatchQueue.main.async {
                    if let self = self {
                        if success {
                            if let completion = self.completion {
                                completion(true)
                            }
                        } else {
                            self.errorLabelHeightConstraint.constant = 40
                            self.loadingView.isHidden = true
                        }
                    }
                }
            }
        }
    }

    @IBAction private func cancel() {
        if let completion = self.completion {
            completion(false)
        }
    }

    private func isPseudoValid(_ pseudo: String?) -> Bool {
        if let pseudo = pseudo, !pseudo.isCompletelyEmpty() {
            return true
        } else {
            return false
        }
    }

}

extension UserPseudoViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
