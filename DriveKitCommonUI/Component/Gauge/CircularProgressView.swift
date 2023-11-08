// swiftlint:disable all
//
//  CircularProgressView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 04/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public final class CircularProgressView: UIView, Nibable {
    @IBOutlet var progressRing: UICircularProgressRing!
    @IBOutlet var imageView: UIImageView!
    private var configuration: ConfigurationCircularProgressView?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    @available(*, deprecated, message: "This method is in ConfigurationCircularProgressView object now.")
    public func getScoreColor(value: Double, steps: [Double]) -> UIColor {
        return UIColor.dkExcellent
    }
    
    public func configure(configuration: ConfigurationCircularProgressView) {
        self.configuration = configuration
        configure()
    }

    private func configure() {
        if let configuration = self.configuration, self.progressRing != nil {
            if let image = configuration.image {
                self.imageView.isHidden = false
                self.imageView.image = image
                self.imageView.tintColor = configuration.fontColor
            } else {
                self.imageView.isHidden = true
            }
            progressRing.isHidden = false
            progressRing.innerRingColor = configuration.ringColor
            progressRing.outerRingColor = UIColor.dkGaugeGray
            progressRing.style = configuration.style
            progressRing.maxValue = CGFloat(configuration.maxValue)
            progressRing.value = CGFloat(configuration.value)
            progressRing.fullCircle = false
            progressRing.startAngle = CGFloat(configuration.startAngle)
            progressRing.endAngle = CGFloat(configuration.endAngle)
            progressRing.outerRingWidth = CGFloat(configuration.ringWidth)
            progressRing.innerRingWidth = CGFloat(configuration.ringWidth)
            progressRing.outerCapStyle = .round
            progressRing.fontColor = configuration.fontColor
            progressRing.font = DKUIFonts.secondary.fonts(size: CGFloat(configuration.fontSize))
            progressRing.valueFormatter = configuration.valueFormatter
        }
    }

}
