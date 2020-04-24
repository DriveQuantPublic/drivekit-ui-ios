//
//  SeparatorView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 17/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SeparatorView : UIView {

    @IBOutlet private weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .none
        let view = Bundle.permissionsUtilsUIBundle?.loadNibNamed("SeparatorView", owner: self, options: nil)?.first as? UIView
        if let view = view {
            view.backgroundColor = .none
            self.addSubview(view)
            self.addConstraints([
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
            self.separatorView.backgroundColor = DKUIColors.neutralColor.color
        }
    }

}
