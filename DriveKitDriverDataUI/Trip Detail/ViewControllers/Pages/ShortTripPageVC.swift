//
//  ShortTripPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ShortTripPageVC: UIViewController {
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var timeSlotLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var messageBackGround: UIView!
    
    var viewModel: ShortTripPageViewModel
    
    init(viewModel: ShortTripPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ShortTripPageVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    func configure() {
        durationLabel.attributedText = Double(self.viewModel.trip.duration).formatSecondDuration().dkAttributedString().font(dkFont: .primary, style: .highlightBig).color(.primaryColor).build()
        
        timeSlotLabel.attributedText = self.viewModel.timeSlotLabelText.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.primaryColor).build()
        
        messageBackGround.backgroundColor = DKUIColors.warningColor.color
        messageBackGround.layer.cornerRadius = 4
        messageBackGround.layer.masksToBounds = true
        
        messageImage.image = DKImages.info.image
        messageImage.tintColor = DKUIColors.warningColor.color
        messageLabel.attributedText = "dk_driverdata_trip_detail_no_score".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.white).build()
    }

}
