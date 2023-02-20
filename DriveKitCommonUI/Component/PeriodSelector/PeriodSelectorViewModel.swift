//
//  PeriodSelectorViewModel.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import DriveKitCoreModule
import Foundation

public class PeriodSelectorViewModel {
    public weak var delegate: PeriodSelectorDelegate?
    public var periodDidChange: (() -> Void)?
    public private(set) var selectedPeriod: DKPeriod
    public private(set) var displayedPeriods: Set<DKPeriod>
    
    public init() {
        self.delegate = nil
        self.periodDidChange = nil
        self.selectedPeriod = .week
        self.displayedPeriods = [.week, .month]
    }

    public func configure(
        displayedPeriods: Set<DKPeriod>,
        selectedPeriod: DKPeriod
    ) {
        self.displayedPeriods = displayedPeriods
        if self.selectedPeriod != selectedPeriod {
            self.selectedPeriod = selectedPeriod
            self.periodDidChange?()
        }
    }

    public func didSelectPeriod(_ period: DKPeriod) {
        if self.selectedPeriod != period {
            let oldPeriod = self.selectedPeriod
            self.selectedPeriod = period
            self.delegate?.periodSelectorDidSwitch(from: oldPeriod, to: period)
        }
    }
    
    func shouldHideButton(for period: DKPeriod) -> Bool {
        self.displayedPeriods.contains(period) == false
    }
}
