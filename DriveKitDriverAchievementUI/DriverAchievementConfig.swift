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
    
    public init(primaryColor: UIColor = UIColor.dkPrimaryColor,
         secondaryColor: UIColor = UIColor.dkSecondaryColor) {
        self.primaryColor = primaryColor
        self.secondaryColor =  secondaryColor
    }
}
