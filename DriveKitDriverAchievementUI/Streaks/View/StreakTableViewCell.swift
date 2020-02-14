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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTitle.text = "dk_streaks_current_title".dkAchievementLocalized()
        bestTitle.text = "dk_streaks_best_title".dkAchievementLocalized()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(streakData : StreakData){
        streakIcon.image = streakData.getIcon()
        theme.text = streakData.getTitle()
        configureCurrent(streak: streakData)
        configureBest(streak: streakData)
    }
    
    private func configureCurrent(streak : StreakData) {
        currentStats.text = "\(streak.getCurrentTripNumber()) - \(streak.getCurrentDistance()) - \(streak.getCurrentDuration())"
        switch streak.status {
        case .best,.inProgress, .initialization:
            currentDate.text = streak.getCurrentDate()
        case .reset:
            currentDate.text = streak.getResetText()
        }
        
    }
    
    private func configureBest(streak : StreakData) {
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
    
    @IBAction func helpClicked(_ sender: Any) {
        
    }
}
