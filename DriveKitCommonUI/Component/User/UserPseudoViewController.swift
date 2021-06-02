//
//  UserPseudoViewController.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 02/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public class UserPseudoViewController : UIViewController {

    public weak var delegate: UserPseudoViewControllerDelegate? = nil
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pseudoInput: UITextField!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var loadingView: UIView!
    private var appeared = false

    init() {
        super.init(nibName: "UserPseudoViewController", bundle: Bundle.driveKitCommonUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.layer.cornerRadius = 10
        self.contentView.backgroundColor = .white

        if let appName = Bundle.main.appName {
            self.titleLabel.attributedText = appName.dkAttributedString().font(dkFont: .primary, style: .headLine1).color(DKUIColors.mainFontColor).build()
        }
        self.descriptionLabel.attributedText = "[TODO]Please enter a pseudo to access this page[TODO]".dkAttributedString().font(dkFont: .primary, style: .normalText).color(DKUIColors.mainFontColor).build()
        self.validateButton.setTitle(DKCommonLocalizable.validate.text(), for: .normal)
        self.cancelButton.setTitle(DKCommonLocalizable.cancel.text(), for: .normal)
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
        //TODO
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancel() {
        self.delegate?.pseudoDidUpdate(success: false)
    }

}
