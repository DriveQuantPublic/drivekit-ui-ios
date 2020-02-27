//
//  StreakTableViewCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 13/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class StreakTableViewCell: UITableViewCell {
    
    @IBOutlet weak var streakIcon: UIImageView!
    @IBOutlet weak var theme: UILabel!
    
    @IBOutlet weak var currentTitle: UILabel!
    @IBOutlet weak var currentStats: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    
    @IBOutlet weak var bestTitle: UILabel!
    @IBOutlet weak var bestStats: UILabel!
    @IBOutlet weak var bestDate: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var currentTripNumberView: UIView!
    @IBOutlet weak var currentTripNumberLabel: UILabel!
    
    @IBOutlet weak var helpView: UIImageView!
    
    private var streak : StreakData!
    private var parentViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTitle.attributedText = "dk_achievements_streaks_current_title".dkAchievementLocalized().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 16)).bold().color(DriveKitUI.shared.colors.mainFontColor).build()
        bestTitle.attributedText = "dk_achievements_streaks_best_title".dkAchievementLocalized().dkAchievementLocalized().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 16)).bold().color(DriveKitUI.shared.colors.mainFontColor).build()
        
    }
    
    func configure(streakData : StreakData, viewController: UIViewController){
        self.streak = streakData
        self.parentViewController = viewController
        streakIcon.image = streakData.getIcon()
        theme.attributedText = streakData.getTitle().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 18)).bold().color(DriveKitUI.shared.colors.mainFontColor).build()
        configureCurrent()
        configureBest()
        configureSlider()
        configureTripNumber()
        configureHelpButton()
    }
    
    private func configureCurrent() {
        let stats = streak.getCurrentTripNumber().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 22)).bold().color(DriveKitUI.shared.colors.secondaryColor).build()
        let tripText = streak.getCurrentTripNumberText().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.secondaryColor).build()
        let secondaryString = " - \(streak.getCurrentDistance()) - \(streak.getCurrentDuration())".dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        stats.append(NSAttributedString(string: " "))
        stats.append(tripText)
        stats.append(secondaryString)
        currentStats.attributedText = stats
        switch streak.status {
        case .best,.inProgress, .initialization:
            currentDate.attributedText = streak.getCurrentDate().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        case .reset:
            currentDate.attributedText = streak.getResetText().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        }
    }
    
    private func configureBest() {
        let stats = streak.getBestTripNumber().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 18)).bold().color(DriveKitUI.shared.colors.mainFontColor).build()
        let secondaryString = " \(streak.getBestTripNumberText()) - \(streak.getBestDistance()) - \(streak.getBestDuration())".dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        stats.append(secondaryString)
        bestStats.attributedText = stats
        switch streak.status {
        case .initialization:
            bestDate.attributedText = "dk_achievements_streaks_empty".dkAchievementLocalized().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        case .inProgress, .reset:
            bestDate.attributedText = streak.getBestDates().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        case .best:
            bestStats.attributedText = "dk_achievements_streaks_congrats".dkAchievementLocalized().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 18)).bold().color(DriveKitUI.shared.colors.mainFontColor).build()
            bestDate.attributedText = "dk_achievements_streaks_congrats_text".dkAchievementLocalized().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 12)).normal().color(DriveKitUI.shared.colors.mainFontColor).build()
        }
    }
    
    private func configureSlider() {
        slider.setValue(Float(streak.progressPercent), animated: false)
        switch streak.status {
        case .inProgress, .initialization, .reset:
            slider.setThumbImage(makeCircleWith(size: CGSize(width: 15, height: 15), backgroundColor: DriveKitUI.shared.colors.secondaryColor), for: .normal)
        case .best:
            slider.setThumbImage(UIImage(), for: .normal)
        }
        
        slider.minimumTrackTintColor = DriveKitUI.shared.colors.secondaryColor
        slider.maximumTrackTintColor = DriveKitUI.shared.colors.mainFontColor
    }
    
    private func configureTripNumber(){
        currentTripNumberView.layer.cornerRadius = 16
        currentTripNumberView.layer.borderWidth = 2.0
        var color = DriveKitUI.shared.colors.mainFontColor
        if streak.status == .best {
            color = DriveKitUI.shared.colors.secondaryColor
        }
        currentTripNumberView.layer.borderColor = color.cgColor
        currentTripNumberLabel.attributedText = self.streak.getBestTripNumber().dkAttributedString().font(DriveKitUI.shared.secondaryFont(size: 18)).bold().color(color).build()
    }
    
    private func configureHelpButton() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(helpClicked))
        helpView.isUserInteractionEnabled = true
        helpView.addGestureRecognizer(singleTap)
        let helpImage = UIImage(named: "dk_help", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        helpView.image = helpImage
        helpView.tintColor = DriveKitUI.shared.colors.secondaryColor
    }
    
    @objc func helpClicked() {
        let alert = UIAlertController(title: streak.getTitle(), message: streak.getDescriptionText(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: nil))
        if let viewController = parentViewController {
            viewController.present(alert, animated: true)
        }
        
    }
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
