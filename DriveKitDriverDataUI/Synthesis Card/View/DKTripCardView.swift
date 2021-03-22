//
//  DKTripCardView.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import UICircularProgressRing

final class DKTripCardView: UIView, Nibable {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var explanationButton: UIButton!
    @IBOutlet private weak var progressRing: UICircularProgressRing!
    @IBOutlet private weak var cardInfoContainer: UIStackView!
    @IBOutlet private weak var bottomText: UILabel!

    var tripCardViewModel: TripCardViewModel? = nil {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title.textColor = DKUIColors.mainFontColor.color
        self.title.font = DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold).applyTo(font: DKUIFonts.primary)

        self.explanationButton.setImage(DKImages.info.image, for: .normal)
    }

    private func update() {
        if let tripCardViewModel = self.tripCardViewModel {
            self.title.text = tripCardViewModel.getTitle()
            self.explanationButton.isHidden = tripCardViewModel.getExplanationContent() == nil
        }
    }

    @IBAction private func showExplanation() {
        #warning("TODO")
    }
}
