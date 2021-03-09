//
//  MapItem.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

public enum MapItem : DKMapItem {
 
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
            return UIImage(named: "dk_history", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distraction.image
        case .synthesis:
            return DKImages.info.image
        case .speeding:
            // TODO: update image
            return DKImages.info.image
        }
    }
    
    public func selectedImage() -> UIImage? {
        switch self {
        case .safety:
            return DKImages.safetyFilled.image
        case .ecoDriving:
            return DKImages.ecoDrivingFilled.image
        case .interactiveMap:
            return UIImage(named: "dk_history_filled", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .distraction:
            return DKImages.distractionFilled.image
        case .synthesis:
            return DKImages.infoFilled.image
        case .speeding:
            // TODO: update image
            return DKImages.infoFilled.image
        }
    }
    
    public func adviceImage() -> UIImage? {
        switch self {
        case .ecoDriving:
            return UIImage(named: "dk_eco_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        case .safety:
            return UIImage(named: "dk_safety_advice", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        default:
            return nil
        }
    }
    
    public func getAdvice(trip: Trip) -> TripAdvice? {
        if let advices = trip.tripAdvices?.allObjects as! [TripAdvice]? {
            if advices.count > 0 {
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
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    public func viewController(trip: Trip, parentViewController: UIViewController, tripDetailViewModel: DKTripDetailViewModel) -> UIViewController {
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
    
    public func canShowMapItem(trip: Trip) -> Bool {
        switch self {
            case .ecoDriving:
                if let ecoDriving = trip.ecoDriving{
                    if ecoDriving.score <= 10 {
                        return true
                    }
                }
            case .safety:
                if let safety = trip.safety{
                    if safety.safetyScore <= 10 {
                        return true
                    }
                }
            case .distraction:
                if let distraction = trip.driverDistraction{
                    if distraction.score <= 10 {
                        return true
                    }
                }
            case .interactiveMap, .synthesis, .speeding:
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
}
