//
//  SafetyPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class SafetyPageView : UIView, Nibable {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventCount: UILabel!
    
    var config: TripListViewConfig = TripListViewConfig()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, image: String, count: Int) {
        DriverDataStyle.applyTripDarkGrey(label: eventTitle)
        eventTitle.text = title
        eventImage.image = UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        eventImage.tintColor = .black
        eventCount.font = eventCount.font.bold.withSize(16)
        eventCount.textColor = config.primaryColor
        eventCount.text = String(count)
    }
    
}
