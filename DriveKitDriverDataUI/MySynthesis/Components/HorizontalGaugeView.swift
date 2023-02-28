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
    private var horizontalGaugeBarView: HorizontalGaugeBarView!

    func configure(viewModel: HorizontalGaugeViewModel) {
        self.viewModel = viewModel
        self.embedSubview(HorizontalGaugeBarView(frame: self.bounds))
    }

}

extension HorizontalGaugeView {
    static func createHorizontalGaugeView(
        configuredWith viewModel: HorizontalGaugeViewModel,
        embededIn containerView: UIView
    ) {
        let horizontalGaugeView = HorizontalGaugeView()
        containerView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        containerView.clipsToBounds = true
        horizontalGaugeView.configure(viewModel: viewModel)
        containerView.embedSubview(horizontalGaugeView)
    }
}

class HorizontalGaugeBarView: DKCustomBarView {
    private var viewModel: HorizontalGaugeViewModel?

    override func draw(_ rect: CGRect) {
        var barViewItems: [DKCustomBarViewItem] = [
            DKCustomBarViewItem(percent: 0.25, color: .red),
            DKCustomBarViewItem(percent: 0.4, color: .orange),
            DKCustomBarViewItem(percent: 0.2, color: .yellow),
            DKCustomBarViewItem(percent: 0.1, color: .green),
            DKCustomBarViewItem(percent: 0.034, color: .blue),
            DKCustomBarViewItem(percent: 0.016, color: .cyan)
        ]
        draw(items: barViewItems, rect: CGRect(x: 10, y: 100, width: self.bounds.size.width - 20, height: 12), radius: 6)
    }

    func configure(viewModel: HorizontalGaugeViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}
