//
//  EcoDrivingPageView.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 15/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//
import UIKit
import DriveKitCommonUI

final class EcoDrivingPageView : UIView, Nibable {

    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, image: String) {
        DriverDataStyle.applyTripDarkGrey(label: eventTitle)
        eventTitle.text = title
        eventImage.image = UIImage(named: image, in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        eventImage.tintColor = .black
    }
    
}
