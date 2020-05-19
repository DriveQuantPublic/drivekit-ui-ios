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
    var tripsLeft: Int = 0
    
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
        tripsLeft = Int(round(Double(level.threshold) - level.progressValue))
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
    
    @objc public func configure() {
        self.title = viewModel.level?.nameKey.dkAchievementLocalized()
        imageView.image = UIImage(named: tripsLeft > 0 ? viewModel.level!.defaultIconKey : viewModel.level!.iconKey,
                                  in: .driverAchievementUIBundle,
                                  compatibleWith: nil)
        goalTitleLabel.attributedText = "badge_detail_goal_title".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        goalTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        goalDescriptionLabel.attributedText = viewModel.level!.descriptionKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        progressTitleLabel.attributedText = "badge_your_progress_title".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        progressTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        if tripsLeft > 0 {
            let tripsLeftAttrString = String(describing: tripsLeft).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
            progressDescriptionLabel.attributedText = viewModel.level!.progressKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).buildWithArgs(tripsLeftAttrString)
        } else {
            progressDescriptionLabel.attributedText = viewModel.level!.congratsKey.dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        }
        initProgressRing()
        closeButton.setAttributedTitle(DKCommonLocalizable.close.text().uppercased().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).build(), for: .normal)
        closeButton.contentHorizontalAlignment = .right
    }

    private func initProgressRing() {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(viewModel.level!.threshold)
        progressRing.value = CGFloat(viewModel.level!.progressValue)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.innerRingWidth = 15
        progressRing.outerRingWidth = 0
        progressRing.shouldShowValueText = false
        if tripsLeft <= 0 {
            switch viewModel.level?.level {
            case .bronze:
                progressRing.innerRingColor = UIColor(hex: 0xbd5e4a)
            case .silver:
                progressRing.innerRingColor = UIColor(hex: 0xa8a8a3)
            case .gold:
                progressRing.innerRingColor = UIColor(hex: 0xf9ed9e)
            case .none:
                progressRing.innerRingColor = UIColor(hex: 0xF0F0F0)
            }
        } else {
            progressRing.innerRingColor = UIColor(hex: 0xF0F0F0)
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
