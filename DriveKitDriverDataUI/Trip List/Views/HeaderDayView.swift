//
//  HeaderDayView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 07/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class HeaderDayView: UIView, Nibable {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(headerDay: HeaderDay, trips: TripsByDate) {
        self.setupAsHeader(leftText: trips.date.dateToDay(), rightText: headerDay.text(trips: trips.trips), isRounded: true)
    }
    
    func setupAsHeader(backGroundColor: UIColor = UIColor.dkHeaderTripListBackground, fontColor: UIColor = .black, fontSize: CGFloat = 14, leftText: String, rightText: String, isRounded: Bool = false) {
        self.rightLabel.text = rightText
        self.rightLabel.font = rightLabel.font.withSize(fontSize)
        self.rightLabel.textColor = fontColor
        
        self.leftLabel.text = leftText
        self.leftLabel.font = leftLabel.font.withSize(fontSize)
        self.leftLabel.textColor = fontColor
        
        self.backgroundView.backgroundColor = backGroundColor
        if isRounded {
            self.backgroundView.layer.cornerRadius = 4
            self.backgroundView.layer.masksToBounds = true
        } else {
            self.backgroundColor = backGroundColor
        }
    }
}

