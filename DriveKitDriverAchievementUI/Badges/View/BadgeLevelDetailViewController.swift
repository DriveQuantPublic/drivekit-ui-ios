//
//  BadgeLevelDetailView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/14/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBAchievementAccess
import DriveKitDriverAchievement
import UICircularProgressRing

class BadgeLevelDetailViewController: DKUIViewController {
    
    var viewModel: BadgeLevelViewModel = BadgeLevelViewModel()
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalTitleSeparator: UIView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var progressTitleSeparator: UIView!
    @IBOutlet weak var progressDescriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    public init(level: DKBadgeLevel) {
        viewModel.level = level
        super.init(nibName: String(describing: BadgeLevelDetailViewController.self),
                   bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public func configure() {
        imageView.image = UIImage(named: viewModel.level!.iconKey)
        goalTitleLabel.attributedText = "L'objectif".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        goalDescriptionLabel.attributedText = viewModel.level!.descriptionKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.complementaryFontColor).build()
        progressTitleLabel.attributedText = "Votre avancement".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        progressDescriptionLabel.attributedText = viewModel.level!.progressKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.complementaryFontColor).build()
    }
}
