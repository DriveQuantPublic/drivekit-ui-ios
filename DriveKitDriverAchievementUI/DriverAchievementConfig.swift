//
//  DriverAchievementConfig.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 17/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class DriverAchievementConfig {
    
    var primaryColor: UIColor
    var secondaryColor: UIColor
    var primaryFont : UIFont
    
    public init(primaryColor: UIColor = UIColor.dkPrimaryColor,
         secondaryColor: UIColor = UIColor.dkSecondaryColor,
         primaryFont : UIFont = UIFont.systemFont(ofSize: CGFloat(UIFont.systemFontSize), weight: .medium)) {
        self.primaryColor = primaryColor
        self.secondaryColor =  secondaryColor
        self.primaryFont = primaryFont
    }
}
