// swiftlint:disable no_magic_numbers
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
        self.layer.cornerRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.backgroundColor = .white
    }
}
