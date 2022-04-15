//
//  DashboardViewModel.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverDataUI
import DriveKitTripAnalysisModule

class DashboardViewModel {
    weak var delegate: DashboardViewModelDelegate?
    private var currentState: State

    init() {
        self.currentState = DriveKitTripAnalysis.shared.getRecorderState()
        TripListenerController.shared.addSdkStateChangeListener(self)
    }

    deinit {
        TripListenerController.shared.removeSdkStateChangeListener(self)
    }

    func getStartStopTripButtonTitle() -> String {
        if isAnalysingTrip() {
            return "stop_trip".keyLocalized()
        } else {
            return "start_trip".keyLocalized()
        }
    }

    func getSynthesisCardView() -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsSynthesisCardsView()
    }

    func getLastTripView(parentViewController: UIViewController) -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsView(parentViewController: parentViewController)
    }

    func startStopTrip() {
        if isAnalysingTrip() {
            DriveKitTripAnalysis.shared.stopTrip()
        } else {
            DriveKitTripAnalysis.shared.startTrip()
        }
    }

    func isAnalysingTrip() -> Bool {
        return isAnalysingTrip(state: self.currentState)
    }

    private func isAnalysingTrip(state: State) -> Bool {
        return state == .starting || state == .running || state == .stopping || state == .sending
    }
}

extension DashboardViewModel: SdkStateChangeListener {
    func sdkStateChanged(state: State) {
        let needUpdate = isAnalysingTrip(state: self.currentState) != isAnalysingTrip(state: state)
        self.currentState = state
        if needUpdate {
            self.delegate?.updateStartStopButton()
        }
    }
}
