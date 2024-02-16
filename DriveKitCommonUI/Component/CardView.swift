//
//  CardView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 14/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class CardView: UIView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        applyCardStyle()
        self.backgroundColor = .white
    }
}
