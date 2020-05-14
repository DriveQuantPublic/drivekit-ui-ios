//
//  BadgeLevelView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBAchievementAccess
import UICircularProgressRing

final class BadgeLevelView : UIView, Nibable {
    var level: DKLevel = .bronze
    var treshold: Float = 0.0
    var progress: Float = 0.0

    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(level: DKLevel,
                          imageKey: String,
                          treshold: Float,
                          progress: Float,
                          name: String) {
        self.level = level
//        self.badgeImage.image = UIImage(named: imageKey)
        self.treshold = treshold
        self.progress = progress
        self.nameLabel.text = name
        initProgressRing()
    }
    
    private func initProgressRing() {
//        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
//        progressRing.fullCircle = true
//        progressRing.maxValue = CGFloat(treshold)
//        progressRing.value = CGFloat(progress)
//        progressRing.startAngle = 270
//        progressRing.endAngle = 45
//        progressRing.outerRingWidth = 0
//        progressRing.innerRingWidth = 8
//        progressRing.fontColor = .clear
//        switch level {
//        case .bronze:
//            progressRing.innerRingColor = UIColor(hex: 0xbd5e4a)
//        case .silver:
//            progressRing.innerRingColor = UIColor(hex: 0xa8a8a3)
//        case .gold:
//            progressRing.innerRingColor = UIColor(hex: 0xf9ed9e)
//        }
//        progressRing.shouldShowValueText = false
    }
}
