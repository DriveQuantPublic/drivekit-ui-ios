//
//  DKSynthesisCardInfoView.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 06/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class DKSynthesisCardInfoView: UIView, Nibable {
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var label: UILabel!

    var synthesisCardInfoViewModel: SynthesisCardInfoViewModel? = nil {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.icon.tintColor = DKUIColors.mainFontColor.color
        update()
    }

    private func update() {
        if self.icon != nil {
            if let synthesisCardInfoViewModel = self.synthesisCardInfoViewModel {
                self.icon.image = synthesisCardInfoViewModel.getIcon()
                self.label.attributedText = synthesisCardInfoViewModel.getText()
            } else {
                self.icon.image = nil
                self.label.attributedText = nil
            }
        }
    }
}
