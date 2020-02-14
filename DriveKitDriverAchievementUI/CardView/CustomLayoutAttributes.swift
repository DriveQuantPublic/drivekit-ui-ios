//
//  CustomLayoutAttributes.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 13/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class CustomLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var backgroundColor : UIColor = .clear
    var cornerRadius : CGFloat = 0.0
    var masksToBounds : Bool = false
    var shadowColor : UIColor = .clear
    var shadowOffset : CGSize = .zero
    var shadowOpacity : Float = 1

    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! CustomLayoutAttributes
        copy.backgroundColor = backgroundColor
        copy.cornerRadius = cornerRadius
        copy.masksToBounds = masksToBounds
        copy.shadowColor = shadowColor
        copy.shadowOffset = shadowOffset
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CustomLayoutAttributes {
            if( attributes.backgroundColor == backgroundColor  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}
