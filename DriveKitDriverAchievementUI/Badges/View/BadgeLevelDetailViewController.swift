//
//  BadgeLevelDetailView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/14/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDriverAchievement
import UICircularProgressRing

class BadgeLevelDetailViewController: DKUIViewController {
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalTitleSeparator: UIView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var progressTitleSeparator: UIView!
    @IBOutlet weak var progressDescriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
