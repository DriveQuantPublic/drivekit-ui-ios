//
//  StreakTableViewCell.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 13/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

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
        currentTitle.attributedText = "dk_streaks_current_title".dkAchievementLocalized().dkAttributedString().font(UIFont.systemFont(ofSize: 16)).bold().build()
        bestTitle.attributedText = "dk_streaks_best_title".dkAchievementLocalized().dkAchievementLocalized().dkAttributedString().font(UIFont.systemFont(ofSize: 16)).bold().build()
        
    }
    
    func configure(streakData : StreakData, config : DriverAchievementConfig, viewController: UIViewController){
        self.streak = streakData
        self.parentViewController = viewController
        streakIcon.image = streakData.getIcon()
        theme.text = streakData.getTitle()
        configureCurrent(config: config)
        configureBest(config: config)
        configureSlider(config: config)
        configureTripNumber(config: config)
        configureHelpButton(config: config)
    }
    
    private func configureCurrent(config : DriverAchievementConfig) {
        let stats = streak.getCurrentTripNumber().dkAttributedString().font(UIFont.systemFont(ofSize: 22)).bold().color(config.secondaryColor).build()
        let tripText = streak.getCurrentTripNumberText().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().color(config.secondaryColor).build()
        let secondaryString = " - \(streak.getCurrentDistance()) - \(streak.getCurrentDuration())".dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        stats.append(NSAttributedString(string: " "))
        stats.append(tripText)
        stats.append(secondaryString)
        currentStats.attributedText = stats
        switch streak.status {
        case .best,.inProgress, .initialization:
            currentDate.attributedText = streak.getCurrentDate().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        case .reset:
            currentDate.attributedText = streak.getResetText().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        }
    }
    
    private func configureBest(config : DriverAchievementConfig) {
        let stats = streak.getBestTripNumber().dkAttributedString().font(UIFont.systemFont(ofSize: 18)).bold().build()
        let secondaryString = " \(streak.getBestTripNumberText()) - \(streak.getBestDistance()) - \(streak.getBestDuration())".dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        stats.append(secondaryString)
        bestStats.attributedText = stats
        switch streak.status {
        case .initialization:
            bestDate.attributedText = "dk_streaks_empty".dkAchievementLocalized().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        case .inProgress, .reset:
            bestDate.attributedText = streak.getBestDates().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        case .best:
            bestStats.attributedText = "dk_streaks_congrats".dkAchievementLocalized().dkAttributedString().font(UIFont.systemFont(ofSize: 18)).bold().build()
            bestDate.attributedText = "dk_streaks_congrats_text".dkAchievementLocalized().dkAttributedString().font(UIFont.systemFont(ofSize: 12)).normal().build()
        }
    }
    
    private func configureSlider(config : DriverAchievementConfig) {
        slider.setValue(Float(streak.progressPercent), animated: false)
        switch streak.status {
        case .inProgress, .initialization, .reset:
            slider.setThumbImage(makeCircleWith(size: CGSize(width: 15, height: 15), backgroundColor: config.secondaryColor), for: .normal)
        case .best:
            slider.setThumbImage(UIImage(), for: .normal)
        }
        
        slider.minimumTrackTintColor = config.secondaryColor
        slider.maximumTrackTintColor = UIColor.dkGrayText
    }
    
    private func configureTripNumber(config : DriverAchievementConfig){
        currentTripNumberView.layer.cornerRadius = 16
        currentTripNumberView.layer.borderWidth = 2.0
        var color = UIColor.dkGrayText
        if streak.status == .best {
            color = config.secondaryColor
        }
        currentTripNumberView.layer.borderColor = color.cgColor
        currentTripNumberLabel.attributedText = self.streak.getBestTripNumber().dkAttributedString().font(UIFont.systemFont(ofSize: 18)).bold().color(color).build()
    }
    
    private func configureHelpButton(config : DriverAchievementConfig) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(helpClicked))
        helpView.isUserInteractionEnabled = true
        helpView.addGestureRecognizer(singleTap)
        let helpImage = UIImage(named: "dk_help", in: Bundle.driverAchievementUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        helpView.image = helpImage
        helpView.tintColor = config.secondaryColor
    }
    
    @objc func helpClicked() {
        let alert = UIAlertController(title: streak.getTitle(), message: streak.getDescriptionText(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dk_ok".dkAchievementLocalized(), style: .default, handler: nil))
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
