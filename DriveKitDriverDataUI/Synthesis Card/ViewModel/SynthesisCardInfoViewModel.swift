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
    private let trips: [Trip]

    init(synthesisCardInfo: DKSynthesisCardInfo, trips: [Trip]) {
        self.synthesisCardInfo = synthesisCardInfo
        self.trips = trips
    }

    func getIcon() -> UIImage? {
        self.synthesisCardInfo.getIcon()
    }

    func getText() -> NSAttributedString {
        self.synthesisCardInfo.getText(trips: self.trips)
    }
}
