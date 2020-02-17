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
    
    @IBOutlet weak var helpButton: UIButton!
    
    private var streak : StreakData!
    private var parentViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTitle.text = "dk_streaks_current_title".dkAchievementLocalized()
        bestTitle.text = "dk_streaks_best_title".dkAchievementLocalized()
    }
    
    func configure(streakData : StreakData, config : DriverAchievementConfig, viewController: UIViewController){
        self.streak = streakData
        self.parentViewController = viewController
        streakIcon.image = streakData.getIcon()
        theme.text = streakData.getTitle()
        configureCurrent()
        configureBest()
        configureSlider(config: config)
        configureTripNumber(config: config)
        helpButton.addTarget(self, action: #selector(helpClicked), for: .touchUpInside)
    }
    
    private func configureCurrent() {
        currentStats.text = "\(streak.getCurrentTripNumber()) - \(streak.getCurrentDistance()) - \(streak.getCurrentDuration())"
        switch streak.status {
        case .best,.inProgress, .initialization:
            currentDate.text = streak.getCurrentDate()
        case .reset:
            currentDate.text = streak.getResetText()
        }
    }
    
    private func configureBest() {
        switch streak.status {
        case .initialization:
            currentStats.text = "\(streak.getBestTripNumber()) - \(streak.getBestDistance()) - \(streak.getBestDuration())"
            currentDate.text = "dk_streaks_empty".dkAchievementLocalized()
        case .inProgress, .reset:
            bestStats.text = "\(streak.getBestTripNumber()) - \(streak.getBestDistance()) - \(streak.getBestDuration())"
            bestDate.text = streak.getBestDates()
        case .best:
            bestStats.text = "dk_streaks_congrats".dkAchievementLocalized()
            bestDate.text = "dk_streaks_congrats_text".dkAchievementLocalized()
        }
    }
    
    private func configureSlider(config : DriverAchievementConfig) {
        currentTripNumberLabel.text = String(format: "%d", streak.streak.current?.tripNumber ?? 0)
        slider.setValue(Float(streak.progressPercent), animated: false)
        switch streak.status {
        case .best, .inProgress:
            slider.setThumbImage(makeCircleWith(size: CGSize(width: 10, height: 10), backgroundColor: config.secondaryColor), for: .normal)
        case .initialization,.reset:
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
        currentTripNumberLabel.textColor = color
        currentTripNumberLabel.text = String(format: "%d", streak.streak.current?.tripNumber ?? 0)
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
