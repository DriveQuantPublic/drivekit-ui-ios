// swiftlint:disable all
//
//  TripListenerManager.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import CoreLocation

class TripListenerManager {
    static let shared: TripListenerManager = TripListenerManager()

    private init() {

    }

    func addTripListener(_ tripListener: TripListener) {
        DriveKitTripAnalysis.shared.addTripListener(tripListener)
    }

    func removeTripListener(_ tripListener: TripListener) {
        DriveKitTripAnalysis.shared.removeTripListener(tripListener)
    }

    func addSdkStateChangeListener(_ sdkStateChangeListener: SdkStateChangeListener) {
        addTripListener(SdkStateChangeListenerProxy(sdkStateChangeListener))
    }

    func removeSdkStateChangeListener(_ sdkStateChangeListener: SdkStateChangeListener) {
        removeTripListener(SdkStateChangeListenerProxy(sdkStateChangeListener))
    }
}

@objc protocol SdkStateChangeListener {
    func sdkStateChanged(state: State)
}

class SdkStateChangeListenerProxy: TripListener {
    var sdkStateChangeListener: SdkStateChangeListener
    
    init(_ sdkStateChangeListener: SdkStateChangeListener) {
        self.sdkStateChangeListener = sdkStateChangeListener
    }
    
    func sdkStateChanged(state: State) {
        self.sdkStateChangeListener.sdkStateChanged(state: state)
    }
    
    func tripStarted(startMode: StartMode) {}

    func tripPoint(tripPoint: TripPoint) {}

    func tripFinished(post: PostGeneric, response: PostGenericResponse) {}

    func tripCancelled(cancelTrip: CancelTrip) {}

    func tripSavedForRepost() {}

    func beaconDetected() {}

    func significantLocationChangeDetected(location: CLLocation) {}

    func potentialTripStart(startMode: StartMode) {}

    func crashDetected(crashInfo: DKCrashInfo) {}

    func crashFeedbackSent(
        crashInfo: DKCrashInfo,
        feedbackType: DKCrashFeedbackType,
        severity: DKCrashFeedbackSeverity
    ) {}
}
