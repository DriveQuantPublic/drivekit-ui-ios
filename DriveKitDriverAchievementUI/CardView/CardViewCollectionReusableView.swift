//
//  CardViewCollectionReusableView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 13/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class CardViewCollectionReusableView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let attributes = layoutAttributes as! CustomLayoutAttributes
        self.backgroundColor = attributes.backgroundColor
        self.layer.cornerRadius = attributes.cornerRadius
        self.layer.masksToBounds = attributes.masksToBounds
        self.layer.shadowOffset = attributes.shadowOffset
        self.layer.shadowColor = attributes.shadowColor.cgColor
        self.layer.shadowOpacity = attributes.shadowOpacity
    }
}
