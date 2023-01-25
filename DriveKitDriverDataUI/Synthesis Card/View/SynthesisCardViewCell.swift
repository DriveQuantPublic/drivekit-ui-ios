// swiftlint:disable all
//
//  SynthesisCardViewCell.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class SynthesisCardViewCell: UICollectionViewCell {
    private let cardView: SynthesisCardView
    var viewModel: SynthesisCardViewModel? {
        didSet {
            self.cardView.synthesisCardViewModel = self.viewModel
        }
    }

    override init(frame: CGRect) {
        let cardView = SynthesisCardView.viewFromNib
        self.cardView = cardView
        super.init(frame: frame)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cardView)
        self.addConstraints([
            cardView.topAnchor.constraint(equalTo: self.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cardView.leftAnchor.constraint(equalTo: self.leftAnchor),
            cardView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
