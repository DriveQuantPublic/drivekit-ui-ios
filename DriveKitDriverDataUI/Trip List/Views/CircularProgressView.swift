//
//  CircularProgressView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 04/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import UICircularProgressRing

final class CircularProgressView: UIView, Nibable {
    @IBOutlet var progressRing: UICircularProgressRing!
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getScoreColor(value: Double, steps: [Double]) -> UIColor {
        if value <= steps[0]{
            return UIColor.dkVeryBad
        }else if value <= steps[1]{
            return UIColor.dkBad
        }else if value <= steps[2]{
            return UIColor.dkBadMean
        }else if value <= steps[3]{
            return UIColor.dkMean
        }else if value <= steps[4]{
            return UIColor.dkGoodMean
        }else if value <= steps[5]{
            return UIColor.dkGood
        }
        return UIColor.dkExcellent
    }
    
    func configure(configuration: ConfigurationCircularProgressView){
        if let image = configuration.image {
            self.imageView.isHidden = false
            self.imageView.image = image
            self.imageView.tintColor = configuration.fontColor
        } else {
            self.imageView.isHidden = true
        }
        progressRing.isHidden = false
        progressRing.innerRingColor = self.getScoreColor(value: configuration.value, steps: configuration.steps)
        progressRing.outerRingColor = UIColor.dkGaugeGray
        progressRing.style = configuration.style
        progressRing.maxValue = CGFloat(configuration.maxValue)
        progressRing.value = CGFloat(configuration.value)
        progressRing.fullCircle = false
        progressRing.startAngle = CGFloat(45)
        progressRing.endAngle = CGFloat(270)
        progressRing.outerRingWidth = CGFloat(configuration.ringWidth)
        progressRing.innerRingWidth = CGFloat(configuration.ringWidth)
        progressRing.outerCapStyle = .round
        progressRing.fontColor = configuration.fontColor
        progressRing.font = UIFont.systemFont(ofSize: CGFloat(configuration.fontSize), weight: .medium)
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: configuration.valueIndicator, rightToLeft: false, showFloatingPoint: configuration.showFloatingPoint, decimalPlaces: configuration.decimalPlaces)
        
    }
    
}
