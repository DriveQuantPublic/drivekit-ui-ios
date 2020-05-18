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
        self.title = viewModel.level?.nameKey.dkAchievementLocalized()
        imageView.image = UIImage(named: viewModel.level!.progressValue >= Double(viewModel.level!.threshold) ? viewModel.level!.iconKey : viewModel.level!.defaultIconKey,
        in: .driverAchievementUIBundle,
        compatibleWith: nil)
        goalTitleLabel.attributedText = "L'objectif".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        goalTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        goalDescriptionLabel.attributedText = viewModel.level!.descriptionKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        progressTitleLabel.attributedText = "Votre avancement".dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        progressTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        progressDescriptionLabel.attributedText = viewModel.level!.progressKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        initProgressRing()
        closeButton.setAttributedTitle(DKCommonLocalizable.close.text().uppercased().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).build(), for: .normal)
        closeButton.contentHorizontalAlignment = .right
    }

    public func initProgressRing() {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(viewModel.level!.threshold)
        progressRing.value = CGFloat(viewModel.level!.progressValue)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.outerRingWidth = 15
        progressRing.shouldShowValueText = false
        if viewModel.level!.progressValue >= Double(viewModel.level!.threshold) {
            switch viewModel.level?.level {
            case .bronze:
                progressRing.outerRingColor = UIColor(hex: 0xbd5e4a)
            case .silver:
                progressRing.outerRingColor = UIColor(hex: 0xa8a8a3)
            case .gold:
                progressRing.outerRingColor = UIColor(hex: 0xf9ed9e)
            case .none:
                progressRing.outerRingColor = UIColor(hex: 0xF0F0F0)
            }
        } else {
            progressRing.outerRingColor = UIColor(hex: 0xF0F0F0)
        }

    }
}
