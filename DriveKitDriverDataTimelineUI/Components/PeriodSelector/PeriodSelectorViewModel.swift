//
//  PeriodSelectorViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDBTripAccessModule

class PeriodSelectorViewModel {
    weak var delegate: PeriodSelectorDelegate?
    var periodDidChange: (() -> Void)?
    private(set) var selectedPeriod: DKTimelinePeriod = .week
    private(set) var displayedPeriods: [DKTimelinePeriod] = [.week, .month]

    func configure(
        displayedPeriods: [DKTimelinePeriod],// = [.week, .month],
        selectedPeriod: DKTimelinePeriod
    ) {
        self.displayedPeriods = displayedPeriods
        if self.selectedPeriod != selectedPeriod {
            self.selectedPeriod = selectedPeriod
            self.periodDidChange?()
        }
    }

    func didSelectPeriod(_ period: DKTimelinePeriod) {
        if self.selectedPeriod != period {
            self.selectedPeriod = period
            self.delegate?.periodSelectorDidSelectPeriod(period)
        }
    }
    
    func shouldHideButton(for period: DKTimelinePeriod) -> Bool {
        self.displayedPeriods.contains(period) == false
    }
}
