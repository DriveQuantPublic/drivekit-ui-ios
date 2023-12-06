//
//  CircleView.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 01/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = self.bounds.size
        let half = 0.5
        self.layer.cornerRadius = max(size.width, size.height) * half
    }

}
