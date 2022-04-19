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

    init() {
        TripListenerController.shared.addSdkStateChangeListener(self)
    }

    deinit {
        TripListenerController.shared.removeSdkStateChangeListener(self)
    }

    func getStartStopTripButtonTitle() -> String {
        if DriveKitTripAnalysis.shared.isTripRunning() {
            return "stop_trip".keyLocalized()
        } else {
            return "start_trip".keyLocalized()
        }
    }

    func getSynthesisCardsView() -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsSynthesisCardsView()
    }

    func getLastTripsView(parentViewController: UIViewController) -> UIView {
        return DriveKitDriverDataUI.shared.getLastTripsView(parentViewController: parentViewController)
    }

    func startStopTrip() {
        if DriveKitTripAnalysis.shared.isTripRunning() {
            DriveKitTripAnalysis.shared.stopTrip()
        } else {
            DriveKitTripAnalysis.shared.startTrip()
        }
    }
}

extension DashboardViewModel: SdkStateChangeListener {
    func sdkStateChanged(state: State) {
        self.delegate?.updateStartStopButton()
    }
}
