// swiftlint:disable all
//
//  CenteredImageView.swift
//  IFPClient
//
//
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class AlternativeTripImageView: UIView, Nibable {

    @IBOutlet private(set) weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = DKImages.noScore.image
    }

}
