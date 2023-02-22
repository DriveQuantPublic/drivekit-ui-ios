// swiftlint:disable all
//
//  VehiclesViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 19/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule

struct VehiclesViewModel {
    func getDescriptionAttibutedText() -> NSAttributedString {
        return "vehicle_intro_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
    }

    func getTitleAttributedText() -> NSAttributedString {
        let iconString = "ⓘ".dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.secondaryColor).build()
        let titleString = "vehicle_intro_title".keyLocalized().appending("  ").dkAttributedString().font(dkFont: .primary, style: .headLine1).color(.mainFontColor).buildWithArgs(iconString)
        return titleString
    }

    func areVehiclesConfigured(completion: @escaping (Bool) -> Void) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: .cache) { _, vehicles in
            DispatchQueue.dispatchOnMainThread {
                completion(!vehicles.isEmpty)
            }
        }
    }
}
