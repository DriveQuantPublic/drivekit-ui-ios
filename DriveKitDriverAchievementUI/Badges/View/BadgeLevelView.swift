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
    var threshold: Float = 0.0
    var progress: Float = 0.0
    var badgeLevel: DKBadgeLevel? = nil

    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc func goToDetailView() {
        NotificationCenter.default.post(name: NSNotification.Name("goToDetailView"),
                                        object: nil,
                                        userInfo: ["badgeLevel": badgeLevel!])
    }
    
    public func configure(level: DKBadgeLevel) {
        badgeLevel = level
        threshold = Float(level.threshold)
        progress = Float(level.progressValue)
        badgeImage.image = UIImage(named: progress >= threshold ? level.iconKey : level.defaultIconKey,
                                   in: .driverAchievementUIBundle,
                                   compatibleWith: nil)
        nameLabel.attributedText = level.nameKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        initProgressRing()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.goToDetailView)))
    }
    
    private func initProgressRing() {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(threshold)
        progressRing.value = CGFloat(progress)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.outerRingWidth = 8
        progressRing.shouldShowValueText = false
        if progress >= threshold {
            switch badgeLevel?.level {
            case .bronze:
                progressRing.outerRingColor = UIColor(hex: 0xbd5e4a)
            case .silver:
                progressRing.outerRingColor = UIColor(hex: 0xa8a8a3)
            case .gold:
                progressRing.outerRingColor = UIColor(hex: 0xf9ed9e)
            case .none:
                progressRing.outerRingColor = UIColor(hex: 0xF0F0F0)
            }
        } else {
            progressRing.outerRingColor = UIColor(hex: 0xF0F0F0)
        }
    }
}
