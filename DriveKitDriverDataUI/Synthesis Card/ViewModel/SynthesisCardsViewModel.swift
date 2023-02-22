// swiftlint:disable all
//
//  SynthesisCardsViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

struct SynthesisCardsViewModel {
    let synthesisCardViewModels: [SynthesisCardViewModel]

    init(synthesisCards: [DKSynthesisCard]) {
        self.synthesisCardViewModels = synthesisCards.map { SynthesisCardViewModel(synthesisCard: $0) }
    }
}
