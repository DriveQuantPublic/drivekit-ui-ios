// swiftlint:disable all
//
//  PicturedIndicatorView.swift
//  IFPClient
//
//  Created by Romain BOUSQUET on 11/03/2017.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class PicturedIndicatorView: UIView, Nibable {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!

    func configure(title: String, image: UIImage?) {
        titleLabel.attributedText = title.dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        configureImage(image: image)
	}

    private func configureImage(image: UIImage?) {
		imageView.image = image
        imageView.tintColor = .black
	}
}
