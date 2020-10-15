//
//  BadgeLevelDetailView.swift
//  DriveKitDriverAchievementUI
//
//  Created by Fanny Tavart Pro on 5/14/20.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCommonUI
import DriveKitDBAchievementAccessModule
import DriveKitDriverAchievementModule
import UICircularProgressRing

class BadgeLevelDetailViewController: DKUIViewController {
    
    let viewModel: BadgeLevelViewModel

    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalTitleSeparator: UIView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var progressTitleSeparator: UIView!
    @IBOutlet weak var progressDescriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    init(level: DKBadgeCharacteristics) {
        viewModel = BadgeLevelViewModel(level: level)
        super.init(nibName: String(describing: BadgeLevelDetailViewController.self),
                   bundle: Bundle.driverAchievementUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc public func configure() {
        self.title = viewModel.title
        imageView.image = UIImage(named: viewModel.iconKey,
                                  in: .driverAchievementUIBundle,
                                  compatibleWith: nil)
        goalTitleLabel.attributedText = "badge_detail_goal_title".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        goalTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        goalDescriptionLabel.attributedText = viewModel.description.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        progressTitleLabel.attributedText = "badge_your_progress_title".dkAchievementLocalized().dkAttributedString().font(dkFont: .primary, style: .highlightSmall).color(.primaryColor).build()
        progressTitleSeparator.backgroundColor = DKUIColors.neutralColor.color
        if viewModel.tripsLeft > 0 {
            let tripsLeftAttrString = String(describing: viewModel.tripsLeft).dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
            progressDescriptionLabel.attributedText = viewModel.progress.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).buildWithArgs(tripsLeftAttrString)
        } else {
            progressDescriptionLabel.attributedText = viewModel.congrats.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.complementaryFontColor).build()
        }
        initProgressRing()
        closeButton.setAttributedTitle(DKCommonLocalizable.close.text().uppercased().dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).build(), for: .normal)
        closeButton.contentHorizontalAlignment = .right
    }

    private func initProgressRing() {
        progressRing.valueFormatter = UICircularProgressRingFormatter(valueIndicator: "", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        progressRing.fullCircle = true
        progressRing.maxValue = CGFloat(viewModel.threshold)
        progressRing.value = CGFloat(viewModel.progressValue)
        progressRing.startAngle = 270
        progressRing.endAngle = 45
        progressRing.innerRingWidth = 12
        progressRing.outerRingWidth = 0
        progressRing.shouldShowValueText = false
        if viewModel.tripsLeft <= 0 {
            switch viewModel.levelValue {
            case .bronze:
                progressRing.innerRingColor = UIColor(hex: 0xbd5e4a)
            case .silver:
                progressRing.innerRingColor = UIColor(hex: 0xa8a8a3)
            case .gold:
                progressRing.innerRingColor = UIColor(hex: 0xf9ed9e)
            @unknown default:
                break
            }
        } else {
            progressRing.innerRingColor = UIColor(hex: 0xF0F0F0)
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
