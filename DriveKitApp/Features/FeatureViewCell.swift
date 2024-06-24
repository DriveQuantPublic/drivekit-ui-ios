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
    @IBOutlet private weak var featureViewContainer: UIView!
    private let featureView: FeatureView = FeatureView.viewFromNib

    override func awakeFromNib() {
        super.awakeFromNib()

        self.featureView.translatesAutoresizingMaskIntoConstraints = false
        self.featureViewContainer.addSubview(self.featureView)
        self.featureView.applyCardStyle()
        let horizontalMargin: CGFloat = 0
        NSLayoutConstraint.activate([
            self.featureView.topAnchor.constraint(equalTo: self.featureViewContainer.topAnchor),
            self.featureView.bottomAnchor.constraint(equalTo: self.featureViewContainer.bottomAnchor),
            self.featureView.leftAnchor.constraint(equalTo: self.featureViewContainer.leftAnchor, constant: horizontalMargin),
            self.featureView.rightAnchor.constraint(equalTo: self.featureViewContainer.rightAnchor, constant: -horizontalMargin)
        ])
    }

    func update(with viewModel: FeatureViewViewModel, parentViewController: UIViewController) {
        self.featureView.update(viewModel: viewModel, parentViewController: parentViewController)
    }
}
