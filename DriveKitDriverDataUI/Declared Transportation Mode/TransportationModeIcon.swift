//
//  TransportationModeIcon.swift
//  IFPClient
//
//  Created by David Bauduin on 03/08/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TransportationModeIcon: UIImageView {
    var isSelected: Bool = false {
        didSet {
            update()
        }
    }
    private let selectionView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = DKUIColors.complementaryFontColor.color

        self.isUserInteractionEnabled = true
        self.selectionView.translatesAutoresizingMaskIntoConstraints = false
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        DKUIColors.secondaryColor.color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.selectionView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.4)
        insertSubview(self.selectionView, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.isSelected {
            let size = self.bounds.size
            let delta = CGFloat(3)
            let selectionViewSize = min(size.width, size.height) - delta
            self.selectionView.frame = CGRect(x: (size.width - selectionViewSize) / 2, y: (size.height - selectionViewSize) / 2, width: selectionViewSize, height: selectionViewSize)
            self.selectionView.layer.cornerRadius = selectionViewSize / 2
        }
    }

    private func update() {
        self.selectionView.isHidden = !self.isSelected
        if self.isSelected {
            setNeedsLayout()
        }
    }
}
