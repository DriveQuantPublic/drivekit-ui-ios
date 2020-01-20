//
//  DriverDataStyles.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class DriverDataStyle {

    static func applyTripHour(label : UILabel){
        label.font = label.font.withSize(14)
        label.textColor = UIColor.dkGrayText
    }
    
    static func applyTripDarkGrey(label : UILabel){
          label.font = label.font.withSize(14)
          label.textColor = UIColor.dkDarkGrayText
    }
    
    static func applyTripListCity(label : UILabel){
        label.font = label.font.withSize(14)
        label.textColor = UIColor.black
    }
    
    static func applyTripMainValue(label : UILabel, color: UIColor){
        label.font = label.font.bold.withSize(14)
        label.textColor =  color
    }
    
    static func applyCircularRingTitle(label: UILabel) {
        label.font = label.font.withSize(20)
        label.textColor = .black
    }
    
    static func applyTitleSynthesis(label: UILabel) {
        label.font = label.font.withSize(12)
        label.textColor = UIColor.dkGrayText
    }
}
