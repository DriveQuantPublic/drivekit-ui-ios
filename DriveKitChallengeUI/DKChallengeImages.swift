//
//  DKChallengeImages.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 18/07/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit

public enum DKChallengeImages: String {
    case firstDriver = "dk_challenge_first_driver",
         result = "dk_challenge_result",
         leaderboard = "dk_challenge_leaderboard",
         trip = "dk_challenge_trip",
         rules = "dk_challenge_rules",
         leaderboardSafety = "dk_challenge_leaderboard_safety",
         leaderboardDistraction = "dk_challenge_leaderboard_distraction",
         leaderboardEcodriving = "dk_challenge_leaderboard_ecodriving",
         leaderboardSpeeding = "dk_challenge_leaderboard_speeding"
    
    public var image: UIImage? {
        if let image = UIImage(named: self.rawValue, in: .main, compatibleWith: nil) {
            return image
        } else {
            return UIImage(named: self.rawValue, in: .challengeUIBundle, compatibleWith: nil)
        }
    }
}
