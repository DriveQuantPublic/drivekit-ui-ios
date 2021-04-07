//
//  DKMapItem.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 26/11/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDBTripAccessModule

public protocol DKMapItem {
    func identifier() -> String
    func normalImage() -> UIImage?
    func selectedImage() -> UIImage?
    func adviceImage() -> UIImage?
    func getAdvice(trip: Trip) -> TripAdvice?
    func viewController(trip: Trip, parentViewController: UIViewController, tripDetailViewModel: DKTripDetailViewModel) -> UIViewController
    func shouldShowDistractionArea() -> Bool
    func shouldShowPhoneDistractionArea() -> Bool
    func displayedMarkers() -> [DKMarkerType]
    func canShowMapItem(trip: Trip) -> Bool
    func overrideShortTrip() -> Bool
    func shouldShowSpeedingArea() -> Bool
}

public enum DKMarkerType {
    case safety, distraction, all
}

public enum DKMapTraceType {
    case phoneCall, unlockScreen
}

extension Array where Element == DKMapItem {
    func firstIndex(of mapItem: DKMapItem) -> Int? {
        return self.firstIndex(where: {$0.identifier() == mapItem.identifier()})
    }
    
    func contains(_ mapItem: DKMapItem) -> Bool {
        return self.firstIndex(of: mapItem) != nil
    }
}
