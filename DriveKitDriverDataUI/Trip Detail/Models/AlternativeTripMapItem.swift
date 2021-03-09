//
//  AlternativeTripMapItem.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 09/12/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class AlternativeTripMapItem : DKMapItem {
    
    func identifier() -> String {
        return "dkAlternativeTrip"
    }
    
    func normalImage() -> UIImage? {
        return DKImages.info.image
    }
    
    func selectedImage() -> UIImage? {
        return DKImages.infoFilled.image
    }
    
    func adviceImage() -> UIImage? {
        return nil
    }
    
    func getAdvice(trip: Trip) -> TripAdvice? {
        return nil
    }
    
    func viewController(trip: Trip, parentViewController: UIViewController, tripDetailViewModel: DKTripDetailViewModel) -> UIViewController {
        return AlternativeTripDetailInfoVC(viewModel: AlternativeTripViewModel(trip: trip), parentView: parentViewController)
    }
    
    func shouldShowDistractionArea() -> Bool {
        return false
    }

    public func shouldShowPhoneDistractionArea() -> Bool {
        return false
    }
    
    func displayedMarkers() -> [DKMarkerType] {
        return []
    }
    
    func canShowMapItem(trip: Trip) -> Bool {
        return true
    }
    
    func overrideShortTrip() -> Bool {
        return true
    }

    func shouldShowSpeedingArea() -> Bool {
        return false
    }
}
