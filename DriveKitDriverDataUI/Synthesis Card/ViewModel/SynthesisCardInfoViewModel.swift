//
//  SynthesisCardInfoViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule

struct SynthesisCardInfoViewModel {
    private let synthesisCardInfo: DKSynthesisCardInfo

    init(synthesisCardInfo: DKSynthesisCardInfo) {
        self.synthesisCardInfo = synthesisCardInfo
    }

    func getIcon() -> UIImage? {
        self.synthesisCardInfo.getIcon()
    }

    func getText() -> NSAttributedString {
        self.synthesisCardInfo.getText()
    }

    func isEmpty() -> Bool {
        return getText().length == 0 && getIcon() == nil
    }
}
