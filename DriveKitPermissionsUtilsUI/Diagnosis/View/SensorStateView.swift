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
    }

}
