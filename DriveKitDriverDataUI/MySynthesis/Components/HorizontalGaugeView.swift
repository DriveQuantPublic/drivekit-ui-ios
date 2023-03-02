// swiftlint:disable no_magic_numbers
//
//  HorizontalGaugeView.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 27/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class HorizontalGaugeView: UIView {
    private var viewModel: HorizontalGaugeViewModel!
    @IBOutlet private weak var  horizontalGaugeBarView: HorizontalGaugeBarView!
    @IBOutlet private weak var  circleCursorImageView: UIImageView!
    @IBOutlet private weak var  circleCursorLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  triangleCursorImageView: UIImageView!
    @IBOutlet private weak var  triangleCursorLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  minScoreImageView: UIImageView!
    @IBOutlet private weak var  minScoreLabel: UILabel!
    @IBOutlet private weak var  minScoreLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  meanScoreImageView: UIImageView!
    @IBOutlet private weak var  meanScoreLabel: UILabel!
    @IBOutlet private weak var  meanScoreLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var  maxScoreImageView: UIImageView!
    @IBOutlet private weak var  maxScoreLabel: UILabel!
    @IBOutlet private weak var  maxScoreLayoutConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.triangleCursorImageView.image = HorizontalGaugeConstants.triangleIcon()
        self.circleCursorImageView.image = HorizontalGaugeConstants.filledCircleIcon(diameter: 12.4)
        self.minScoreImageView.image = HorizontalGaugeConstants.circleIcon()
        self.maxScoreImageView.image = HorizontalGaugeConstants.circleIcon()
        self.meanScoreImageView.image = HorizontalGaugeConstants.circleIcon()
    }

    func configure(viewModel: HorizontalGaugeViewModel) {
        self.viewModel = viewModel
        self.horizontalGaugeBarView.configure(viewModel: viewModel)
        updateUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    func updateUI() {
        self.circleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.horizontalGaugeBarView.bounds.size.width
        self.triangleCursorLayoutConstraint.constant = viewModel.scoreOffsetPercent * self.horizontalGaugeBarView.bounds.size.width
        self.minScoreLayoutConstraint.constant = viewModel.minOffsetPercent * self.horizontalGaugeBarView.bounds.size.width
        self.maxScoreLayoutConstraint.constant = viewModel.maxOffsetPercent * self.horizontalGaugeBarView.bounds.size.width
        self.meanScoreLayoutConstraint.constant = viewModel.meanOffsetPercent * self.horizontalGaugeBarView.bounds.size.width

        self.minScoreLabel.text = String(self.viewModel.min)
        self.maxScoreLabel.text = String(self.viewModel.max)
        self.meanScoreLabel.text = String(self.viewModel.mean)
    }
}

extension HorizontalGaugeView {
    static func createHorizontalGaugeView(
        configuredWith viewModel: HorizontalGaugeViewModel,
        embededIn containerView: UIView
    ) {
        guard let horizontalGaugeView = Bundle.driverDataUIBundle?.loadNibNamed(
            "HorizontalGaugeView",
            owner: nil
        )?.first as? HorizontalGaugeView else {
            preconditionFailure("Can't find bundle or nib for HorizontalGaugeView")
        }

        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
        containerView.embedSubview(horizontalGaugeView)
        horizontalGaugeView.configure(viewModel: viewModel)
    }
}

class HorizontalGaugeBarView: DKCustomBarView {
    private var viewModel: HorizontalGaugeViewModel?

    override func draw(_ rect: CGRect) {
        let barViewItems: [DKCustomBarViewItem] = self.viewModel?.getBarItemsToDraw() ?? []
        draw(items: barViewItems, rect: self.bounds, radius: self.bounds.size.height / 2)
    }

    func configure(viewModel: HorizontalGaugeViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}

enum HorizontalGaugeConstants {
    static let defaultCircleColor = UIColor(hex: 0x036A82)
    
    static func circleIcon(diameter: CGFloat = 12, insideColor: UIColor = .white) -> UIImage? {
        let scale: CGFloat = 0
        let lineWidth: CGFloat = 4
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let path = UIBezierPath(
            arcCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2 - lineWidth / 2,
            startAngle: 0,
            endAngle: 2 * Double.pi,
            clockwise: true)
        path.lineWidth = lineWidth
        defaultCircleColor.setStroke()
        insideColor.setFill()
        path.stroke()
        path.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func filledCircleIcon(diameter: CGFloat = 12) -> UIImage? {
        circleIcon(diameter: diameter, insideColor: self.defaultCircleColor)
    }

    static func triangleIcon(width: CGFloat = 20) -> UIImage? {
        let scale: CGFloat = 0
        let size = CGSize(width: width, height: width)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width / 2, y: width))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        defaultCircleColor.setFill()
        bezierPath.fill()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
