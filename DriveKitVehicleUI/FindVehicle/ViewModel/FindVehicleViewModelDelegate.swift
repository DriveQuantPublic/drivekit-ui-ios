//
//  FindVehicleViewModelDelegate.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 06/11/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

protocol FindVehicleViewModelDelegate: AnyObject {
    func userLocationUpdateFinished()
    func addressGeocodingFinished()
    func directionsRequestFinished()
}
