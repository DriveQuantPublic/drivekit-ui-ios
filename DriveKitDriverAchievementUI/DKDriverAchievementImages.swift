// swiftlint:disable convenience_type
//
//  DKDriverAchievementImages.swift
//  DriveKitDriverAchievementUI
//
//  Created by Amine Gahbiche on 18/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public class DKDriverAchievementImages {
    public static func image(named name: String) -> UIImage? {
        if let image = UIImage(named: name, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: name, in: .driverAchievementUIBundle, compatibleWith: nil)
        }
    }
}
