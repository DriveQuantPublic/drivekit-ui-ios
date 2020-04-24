//
//  GlobalStateView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 20/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class GlobalStateView : UIView {

    var viewModel: GlobalStateViewModel? = nil {
        didSet {
            self.update()
        }
    }
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var info: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let view = Bundle.permissionsUtilsUIBundle?.loadNibNamed("GlobalStateView", owner: self, options: nil)?.first as? UIView
        if let view = view {
            self.addSubview(view)
            self.addConstraints([
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
    }

    private func update() {
        guard let viewModel = self.viewModel else { return }
        self.statusIcon.image = viewModel.statusIcon
        self.title.attributedText = viewModel.title.dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).build()
        self.info.attributedText = viewModel.info.dkPermissionsUtilsLocalized().dkAttributedString().font(dkFont: .primary, style: .smallText).color(.complementaryFontColor).build()
    }

}
