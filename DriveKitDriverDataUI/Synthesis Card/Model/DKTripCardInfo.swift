//
//  DKTripCardInfo.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 21/03/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule

public protocol DKTripCardInfo {
    func getIcon() -> UIImage?
    func getText(trips: [Trip]) -> NSAttributedString
}

public enum TripCardInfo: DKTripCardInfo {
    case count, distance, duration

    public func getIcon() -> UIImage? {
        let imageName: String
        switch self {
            case .count:
                imageName = "dk_common_trip"
            case .distance:
                imageName = "dk_common_road"
            case .duration:
                imageName = "dk_common_clock"
        }
        return UIImage(named: imageName)
    }

    public func getText(trips: [Trip]) -> NSAttributedString {
        #warning("TODO")
        return "TODO".dkAttributedString().build()
    }
}
