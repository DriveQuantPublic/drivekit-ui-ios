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

    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc func goToDetailView(sender: DetailTapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("goToDetailView"),
                                        object: nil,
                                        userInfo: ["badgeLevel": sender.badgeLevel! as DKBadgeLevel])
    }

    @objc public func configure(level: DKBadgeLevel) {
        let badgeLevel = level
        let threshold = Float(level.threshold)
        let progress = Float(level.progressValue)
        badgeImage.image = UIImage(named: progress >= threshold ? level.iconKey : level.defaultIconKey,
                                   in: .driverAchievementUIBundle,
                                   compatibleWith: nil)
        nameLabel.attributedText = level.nameKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        initProgressRing(threshold: threshold, progress: progress, badgeLevel: badgeLevel)
        let tapGesture = DetailTapGestureRecognizer(target: self, action: #selector(self.goToDetailView(sender:)))
        tapGesture.badgeLevel = badgeLevel
        self.addGestureRecognizer(tapGesture)
    }
    
    private func initProgressRing(threshold: Float, progress: Float, badgeLevel: DKBadgeLevel) {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(threshold)
        progressRing.value = CGFloat(progress)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.innerRingWidth = 8
        progressRing.outerRingWidth = 0
        progressRing.shouldShowValueText = false
        if progress >= threshold {
            switch badgeLevel.level {
            case .bronze:
                progressRing.innerRingColor = UIColor(hex: 0xbd5e4a)
            case .silver:
                progressRing.innerRingColor = UIColor(hex: 0xa8a8a3)
            case .gold:
                progressRing.innerRingColor = UIColor(hex: 0xf9ed9e)
            }
        } else {
            progressRing.innerRingColor = UIColor(hex: 0xF0F0F0)
        }
    }
}

class DetailTapGestureRecognizer: UITapGestureRecognizer {
    var badgeLevel: DKBadgeLevel?
}
