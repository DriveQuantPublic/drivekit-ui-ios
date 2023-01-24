//
//  SeparatorView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 17/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

import DriveKitCommonUI

class SeparatorView: UIView {

    @IBOutlet private weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .none
        let view = Bundle.permissionsUtilsUIBundle?.loadNibNamed("SeparatorView", owner: self, options: nil)?.first as? UIView
        if let view = view {
            view.backgroundColor = .none
            embedSubview(view)
            self.separatorView.backgroundColor = DKUIColors.neutralColor.color
        }
    }

}
