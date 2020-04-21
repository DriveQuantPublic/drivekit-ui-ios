//
//  SensorStateView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 17/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SensorStateView : UIView {

    var viewModel: SensorStateViewModel? = nil {
        didSet {
            self.update()
        }
    }
    @IBOutlet private weak var touchBackground: UIButton!
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var sensorTitle: UILabel!
    @IBOutlet private weak var learnMoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let view = Bundle.permissionsUtilsUIBundle?.loadNibNamed("SensorStateView", owner: self, options: nil)?.first as? UIView
        if let view = view {
            self.addSubview(view)
            self.addConstraints([
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }

        self.touchBackground.setBackgroundImage(UIImage(color: UIColor(white: 0.5, alpha: 0.5)), for: .highlighted)
    }

    private func update() {
        if let viewModel = self.viewModel {
            self.statusIcon.image = viewModel.statusIcon
            self.statusIcon.tintColor = viewModel.statusIconTintColor
            self.sensorTitle.attributedText = viewModel.title.dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
            self.learnMoreLabel.attributedText = viewModel.learnMoreText.dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.secondaryColor).build()
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }

    @IBAction private func showDialog() {
        self.viewModel?.showDialog()
    }

}
