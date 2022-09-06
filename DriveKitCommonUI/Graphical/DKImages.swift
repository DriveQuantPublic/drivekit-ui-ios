//
//  DKImages.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 28/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public enum DKImages: String {
    case ecoAccel = "dk_common_eco_accel",
         info = "dk_common_info",
         infoFilled = "dk_common_info_filled",
         ecoDecel = "dk_common_eco_decel",
         ecoMaintain = "dk_common_eco_maintain",
         ecoDriving = "dk_common_ecodriving",
         ecoDrivingFilled = "dk_common_ecodriving_filled",
         ecoAdvice = "dk_common_eco_advice",
         safetyAccel = "dk_common_safety_accel",
         safetyDecel = "dk_common_safety_decel",
         safetyAdherence = "dk_common_safety_adherence",
         safety = "dk_common_safety",
         safetyFilled = "dk_common_safety_filled",
         safetyAdvice = "dk_common_safety_advice",
         distraction = "dk_common_distraction",
         distractionFilled = "dk_common_distraction_filled",
         speeding = "dk_common_speeding",
         speedingFilled = "dk_common_speeding_filled",
         call = "dk_common_call",
         warning = "dk_common_warning",
         dots = "dk_common_dots",
         jump = "dk_common_jump",
         arrowDown = "dk_common_arrow_down",
         back = "dk_common_back",
         check = "dk_common_check",
         mail = "dk_common_mail",
         calendar = "dk_common_calendar",
         trip = "dk_common_trip",
         road = "dk_common_road",
         clock = "dk_common_clock",
         tripInfoCount = "dk_common_trip_info_count",
         noScore = "dk_no_score",
         rank1 = "dk_common_rank_1",
         rank2 = "dk_common_rank_2",
         rank3 = "dk_common_rank_3",
         emptyData = "dk_common_empty_data"

    public var image: UIImage? {
        let renderingMode: UIImage.RenderingMode
        switch self  {
        case .noScore, .rank1, .rank2, .rank3:
            renderingMode = .automatic
        default:
            renderingMode = .alwaysTemplate
        }
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image.withRenderingMode(renderingMode)
        } else {
            return UIImage(named: self.rawValue, in: .driveKitCommonUIBundle, compatibleWith: nil)?.withRenderingMode(renderingMode)
        }
    }
}
