//
//  TripSimulatorDetailViewModel .swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 22/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import CoreLocation
import DriveKitCoreModule
import DriveKitTripAnalysisModule
import DriveKitTripSimulatorModule

protocol TripSimulatorDetailViewModelDelegate: NSObject {
    func updateNeeded(updatedValue: Double, timestamp: Double)
}

class TripSimulatorDetailViewModel {
    weak var delegate: TripSimulatorDetailViewModelDelegate?
    private var simulatedItem: TripSimulatorItem
    private var lastSimulatedLocation: CLLocation?
    private var currentDuration: Double = 0
    private var durationWhenEnteredStoppingState: Double?
    var velocityBuffer: CircularBuffer<Double> = CircularBuffer(size: 30)

    init(simulatedItem: TripSimulatorItem) {
        self.simulatedItem = simulatedItem
        self.startSimulation()
    }

    func stopSimulation() {
        DriveKitTripSimulator.shared.stop()
    }

    func startSimulation() {
        switch simulatedItem {
        case .trip(let presetTrip):
            DriveKitTripSimulator.shared.start(presetTrip, delegate: self)
        case .crashTrip(let presetCrashConfiguration):
            DriveKitTripSimulator.shared.startCrashTrip(presetCrashConfiguration, delegate: self)
        }
    }

    func getTotalDurationText() -> String {
        let duration: Double
        switch simulatedItem {
        case .trip(let presetTrip):
            duration = presetTrip.getSimulationDuration()
        case .crashTrip(let presetCrashConfiguration):
            duration = presetCrashConfiguration.getPresetTrip().getSimulationDuration()
        }
        return formatDuration(duration: duration)
    }

    func getStateText() -> String {
        let state = DriveKitTripAnalysis.shared.getRecorderState()
        switch state {
        case .inactive:
            return "INACTIVE"
        case .starting:
            return "STARTING"
        case .running:
            return "RUNNING"
        case .stopping:
            return "STOPPING"
        case .sending:
            return "SENDING"
        }
    }

    func getSpentDurationText() -> String {
        return formatDuration(duration: currentDuration)
    }

    func getSpeedText() -> String {
        if let lastSpeed = velocityBuffer.last {
            return lastSpeed.formatSpeedMean()
        } else {
            return "-"
        }
    }

    func shouldDisplayStoppingMessage() -> Bool {
        return DriveKitTripAnalysis.shared.getRecorderState() == .stopping
    }

    func getRemainingTimeToStopText() -> String {
        guard let durationWhenEnteredStoppingState = durationWhenEnteredStoppingState else {
            return ""
        }
        let timeOut: Int = DriveKitTripAnalysis.shared.stopTimeOut
        let remainingDuration = Double(timeOut) - currentDuration + durationWhenEnteredStoppingState
        return formatDuration(duration: remainingDuration)
    }

    func getTripTitle() -> String {
        return simulatedItem.getTitle()
    }

    func getTripDescription() -> String {
        return simulatedItem.getDescription()
    }

    func formatDuration(duration: Double) -> String {
        let durationInt = Int(duration)
        let seconds: Int = durationInt % 60
        let minutes: Int = (durationInt - seconds) / 60
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }
}


extension TripSimulatorDetailViewModel: DKTripSimulatorDelegate {
    func locationSent(location: CLLocation, durationSinceStart: Double) {
        self.lastSimulatedLocation = location
        self.currentDuration = durationSinceStart
        let speedKmH = location.speed * 3600 / 1000
        self.velocityBuffer.append(speedKmH)

        let state = DriveKitTripAnalysis.shared.getRecorderState()
        if state == .stopping {
          if durationWhenEnteredStoppingState == nil {
              durationWhenEnteredStoppingState = durationSinceStart
          }
        } else {
            durationWhenEnteredStoppingState = nil
        }

        DispatchQueue.dispatchOnMainThread { [weak self] in
            if let self = self, let velocity = self.velocityBuffer.last {
                self.delegate?.updateNeeded(updatedValue: velocity, timestamp: self.currentDuration)
            }
        }
    }
}
