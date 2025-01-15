//
//  MapItem.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCoreModule
import DriveKitDBTripAccessModule
import DriveKitCommonUI

public enum MapItem: DKMapItem {
 
    case ecoDriving, safety, distraction, interactiveMap, synthesis, speeding
    
    public func identifier() -> String {
        switch self {
            case .safety:
                return "dkSafety"
            case .ecoDriving:
                return "dkEcoDriving"
            case .interactiveMap:
                return "dkInteractiveMap"
            case .distraction:
                return "dkDistraction"
            case .synthesis:
                return "dkSynthesis"
            case .speeding:
                return "dkSpeeding"
        }
    }
    
    public func normalImage() -> UIImage? {
        switch self {
        case .safety:
            return DKImages.safety.image
        case .ecoDriving:
            return DKImages.ecoDriving.image
        case .interactiveMap:
            return DKDriverDataImages.history.image?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distraction.image
        case .synthesis:
            return DKImages.info.image
        case .speeding:
            return DKImages.speeding.image
        }
    }
    
    public func selectedImage() -> UIImage? {
        switch self {
        case .safety:
            return DKImages.safetyFilled.image
        case .ecoDriving:
            return DKImages.ecoDrivingFilled.image
        case .interactiveMap:
            return DKDriverDataImages.historyFilled.image?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distractionFilled.image
        case .synthesis:
            return DKImages.infoFilled.image
        case .speeding:
            return DKImages.speedingFilled.image
        }
    }
    
    public func adviceImage() -> UIImage? {
        switch self {
        case .ecoDriving:
            return DKImages.ecoAdvice.image?.withRenderingMode(.alwaysTemplate)
        case .safety:
            return DKImages.safetyAdvice.image?.withRenderingMode(.alwaysTemplate)
        default:
            return nil
        }
    }
    
    public func getAdvice(trip: DKTrip) -> DKTripAdvice? {
        if let advices = trip.tripAdvices {
            if !advices.isEmpty {
                switch self {
                case .safety:
                    return advices.filter({$0.theme == "SAFETY"}).first
                case .ecoDriving:
                    return advices.filter({$0.theme == "ECODRIVING"}).first
                case .interactiveMap:
                    return nil
                case .distraction:
                    return nil
                case .synthesis:
                    return nil
                case .speeding:
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func viewController(trip: DKTrip, parentViewController: UIViewController, tripDetailViewModel: DKTripDetailViewModel) -> UIViewController {
        switch self {
            case .ecoDriving:
                let ecoDrivingViewModel = EcoDrivingPageViewModel(trip: trip)
                let ecoDrivingVC = EcoDrivingPageVC(viewModel: ecoDrivingViewModel)
                return ecoDrivingVC
            case .safety:
                let safetyViewModel = SafetyPageViewModel(trip: trip)
                let safetyVC = SafetyPageVC(viewModel: safetyViewModel)
                return safetyVC
            case .distraction:
                let distractionViewModel = DistractionPageViewModel(trip: trip, tripDetailViewModel: tripDetailViewModel)
                let distractionVC = DistractionPageVC(viewModel: distractionViewModel)
                return distractionVC
            case .interactiveMap:
                let historyViewModel = HistoryPageViewModel(tripDetailViewModel: tripDetailViewModel)
                let historyVC = HistoryPageVC(viewModel: historyViewModel)
                return historyVC
            case .synthesis:
                let synthesisViewModel = SynthesisPageViewModel(trip: trip)
                let synthesisPageVC = SynthesisPageVC(viewModel: synthesisViewModel, parentView: parentViewController)
                return synthesisPageVC
            case .speeding:
                let speedingViewModel = SpeedingPageViewModel(trip: trip)
                let speedingPageVC = SpeedingPageVC(viewModel: speedingViewModel)
                return speedingPageVC

        }
    }
    
    public func shouldShowDistractionArea() -> Bool {
        switch self {
            case .ecoDriving, .safety, .synthesis, .speeding:
                return false
            case .distraction, .interactiveMap:
                return true
        }
    }

    public func shouldShowPhoneDistractionArea() -> Bool {
        return self == .distraction
    }
    
    public func displayedMarkers() -> [DKMarkerType] {
        switch self {
            case .ecoDriving, .synthesis, .speeding:
                return []
            case .safety:
                return [.safety]
            case .distraction:
                return [.distraction]
            case .interactiveMap:
                return [.all]
        }
    }
    
    public func canShowMapItem(trip: DKTrip) -> Bool {
        let maxScore: Double = 10
        switch self {
            case .ecoDriving:
                if let ecoDriving = trip.ecoDriving,
                   ecoDriving.score <= maxScore {
                    return true
                }
            case .safety:
                if let safety = trip.safety,
                   safety.safetyScore <= maxScore {
                    return true
                }
            case .distraction:
                if let distraction = trip.driverDistraction,
                   distraction.score <= maxScore {
                    return true
                }
            case .speeding:
                if let speedingStatistics = trip.speedingStatistics,
                   speedingStatistics.score <= maxScore {
                    return true
                }
            case .interactiveMap, .synthesis:
                return true
        }
        return false
    }
    
    public func overrideShortTrip() -> Bool {
        return false
    }

    public func shouldShowSpeedingArea() -> Bool {
        switch self {
            case .ecoDriving, .safety, .synthesis, .distraction, .interactiveMap:
                return false
            case .speeding:
                return true
        }
    }

    func hasAccess() -> Bool {
        let hasAccess: Bool
        switch self {
            case .distraction:
                hasAccess = DriveKitAccess.shared.hasAccess(.phoneDistraction)
            case .ecoDriving:
                hasAccess = DriveKitAccess.shared.hasAccess(.ecoDriving)
            case .safety:
                hasAccess = DriveKitAccess.shared.hasAccess(.safety)
            case .speeding:
                hasAccess = DriveKitAccess.shared.hasAccess(.speeding)
            case .interactiveMap, .synthesis:
                hasAccess = true
        }
        return hasAccess
    }
}
