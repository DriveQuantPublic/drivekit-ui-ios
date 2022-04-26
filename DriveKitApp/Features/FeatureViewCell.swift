//
//  FeatureViewCell.swift
//  DriveKitApp
//
//  Created by David Bauduin on 18/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class FeatureViewCell: UITableViewCell, Nibable {
    private let featureView: FeatureView = FeatureView.viewFromNib

    override func awakeFromNib() {
        super.awakeFromNib()

        self.featureView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.featureView)
        self.featureView.addShadow()
        let verticalMargin: CGFloat = 11
        let horizontalMargin: CGFloat = 8
        NSLayoutConstraint.activate([
            self.featureView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: verticalMargin),
            self.featureView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -verticalMargin),
            self.featureView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: horizontalMargin),
            self.featureView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -horizontalMargin)
        ])
    }

    func update(with viewModel: FeatureViewViewModel, parentViewController: UIViewController) {
        self.featureView.update(viewModel: viewModel, parentViewController: parentViewController)
    }
}
