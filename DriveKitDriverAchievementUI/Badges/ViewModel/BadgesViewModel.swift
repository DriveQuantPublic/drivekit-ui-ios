//
//  BadgesViewModel.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/12/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitDriverAchievement
import DriveKitDBAchievementAccess
import UIKit
import DriveKitCommonUI

class BadgeViewModel {
    
    weak var delegate : BadgeDelegate? = nil
    
    var badges : [DKBadge] = []
    
    init() {
    }
    
    public func updateBadges() {
        DriveKitDriverAchievement.shared.getBadges(completionHandler: {status, badges in
            DispatchQueue.main.async {
                self.badges = badges
                self.delegate?.badgesUpdated()
            }
        })
    }
    
}

protocol BadgeDelegate : AnyObject {
    func badgesUpdated()
}
