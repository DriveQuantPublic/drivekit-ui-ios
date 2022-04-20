//
//  TripListenerController.swift
//  DriveKitApp
//
//  Created by David Bauduin on 15/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import CoreLocation

class TripListenerController {
    static let shared: TripListenerController = TripListenerController()
    private var tripListeners: WeakArray<TripListener> = WeakArray()
    private var sdkStateChangeListeners: WeakArray<SdkStateChangeListener> = WeakArray()

    private init() {

    }

    func addTripListener(_ tripListener: TripListener) {
        self.tripListeners.append(tripListener)
    }

    func removeTripListener(_ tripListener: TripListener) {
        self.tripListeners.remove(tripListener)
    }

    func addSdkStateChangeListener(_ sdkStateChangeListener: SdkStateChangeListener) {
        self.sdkStateChangeListeners.append(sdkStateChangeListener)
    }

    func removeSdkStateChangeListener(_ sdkStateChangeListener: SdkStateChangeListener) {
        self.sdkStateChangeListeners.remove(sdkStateChangeListener)
    }
}

@objc protocol SdkStateChangeListener {
    func sdkStateChanged(state: State)
}

extension TripListenerController: TripListener {
    func tripStarted(startMode: StartMode) {
        for tripListener in self.tripListeners {
            tripListener?.tripStarted(startMode: startMode)
        }
    }

    func tripPoint(tripPoint: TripPoint) {
        for tripListener in self.tripListeners {
            tripListener?.tripPoint(tripPoint: tripPoint)
        }
    }

    func tripFinished(post: PostGeneric, response: PostGenericResponse) {
        for tripListener in self.tripListeners {
            tripListener?.tripFinished(post: post, response: response)
        }
    }

    func tripCancelled(cancelTrip: CancelTrip) {
        for tripListener in self.tripListeners {
            tripListener?.tripCancelled(cancelTrip: cancelTrip)
        }
    }

    func tripSavedForRepost() {
        for tripListener in self.tripListeners {
            tripListener?.tripSavedForRepost()
        }
    }

    func beaconDetected() {
        for tripListener in self.tripListeners {
            tripListener?.beaconDetected()
        }
    }

    func significantLocationChangeDetected(location: CLLocation) {
        for tripListener in self.tripListeners {
            tripListener?.significantLocationChangeDetected(location: location)
        }
    }

    func sdkStateChanged(state: State) {
        for tripListener in self.tripListeners {
            tripListener?.sdkStateChanged(state: state)
        }
        for sdkStateChangeListener in self.sdkStateChangeListeners {
            sdkStateChangeListener?.sdkStateChanged(state: state)
        }
    }

    func potentialTripStart(startMode: StartMode) {
        for tripListener in self.tripListeners {
            tripListener?.potentialTripStart(startMode: startMode)
        }
    }

    func crashDetected(crashInfo: DKCrashInfo) {
        for tripListener in self.tripListeners {
            tripListener?.crashDetected(crashInfo: crashInfo)
        }
    }

    func crashFeedbackSent(crashInfo: DKCrashInfo, feedbackType: DKCrashFeedbackType, severity: DKCrashFeedbackSeverity) {
        for tripListener in self.tripListeners {
            tripListener?.crashFeedbackSent(crashInfo: crashInfo, feedbackType: feedbackType, severity: severity)
        }
    }
}
