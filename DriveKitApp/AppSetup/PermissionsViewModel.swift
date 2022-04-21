//
//  PermissionsViewModel.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 19/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitCommonUI
import DriveKitVehicleModule

struct PermissionsViewModel {
    private let grayColor = UIColor(hex:0x9e9e9e)

    func getDescriptionAttibutedText() -> NSAttributedString {
        return "permissions_intro_description".keyLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(grayColor).build()
    }

    func getTitleAttributedText() -> NSAttributedString {
        let iconString = "ⓘ".dkAttributedString().font(dkFont: .primary, style: .bigtext).color(DKUIColors.secondaryColor.color).build()
        let titleString = "permissions_intro_title".keyLocalized().appending("  ").dkAttributedString().font(dkFont: .primary, style: .bigtext).color(DKUIColors.mainFontColor.color).buildWithArgs(iconString)
        return titleString
    }

    func shouldDisplayVehicle(completion:@escaping (Bool) -> ()) {
        DriveKitVehicle.shared.getVehiclesOrderByNameAsc(type: .cache) { _, vehicles in
            DispatchQueue.dispatchOnMainThread {
                completion(vehicles.count == 0)
            }
        }
    }
}
