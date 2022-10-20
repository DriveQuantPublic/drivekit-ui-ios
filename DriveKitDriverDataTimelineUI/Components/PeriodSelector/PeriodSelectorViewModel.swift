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
    weak var viewDelegate: PeriodSelectorViewModelDelegate?
    private(set) var selectedPeriod: DKTimelinePeriod = .week

    func update(selectedPeriod: DKTimelinePeriod) {
        if self.selectedPeriod != selectedPeriod {
            self.selectedPeriod = selectedPeriod
            self.viewDelegate?.periodSelectorViewModelDidUpdate()
        }
    }

    func didSelectPeriod(_ period: DKTimelinePeriod) {
        if self.selectedPeriod != period {
            self.selectedPeriod = period
            self.delegate?.periodSelectorDidSelectPeriod(period)
        }
    }
}

protocol PeriodSelectorViewModelDelegate: AnyObject {
    func periodSelectorViewModelDidUpdate()
}
