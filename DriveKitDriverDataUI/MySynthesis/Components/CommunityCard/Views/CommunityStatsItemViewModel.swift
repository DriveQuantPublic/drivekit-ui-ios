//
//  CommunityStatsItemViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import Foundation

public struct CommunityStatsItemViewModel {
    public var legendColor: DKUIColors
    public var legendTitle: String
    public var tripCount: Int?
    public var distanceCount: Double?
    public var driverCount: Int?
    
    public var tripCountText: String {
        guard let tripCount else { return "" }
        var text = "\(tripCount) "
        if tripCount > 1 {
            text += DKCommonLocalizable.tripPlural.text()
        } else {
            text += DKCommonLocalizable.tripSingular.text()
        }
        
        return text
    }
    
    public var distanceCountText: String {
        distanceCount?.formatKilometerDistance() ?? ""
    }
    
    public var driverCountText: String {
        guard let driverCount else { return "" }
        return "\(driverCount) " + "dk_driverdata_mysynthesis_drivers".dkDriverDataLocalized()
    }
}
