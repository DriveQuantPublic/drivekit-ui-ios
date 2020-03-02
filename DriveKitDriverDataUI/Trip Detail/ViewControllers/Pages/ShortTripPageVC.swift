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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configure()
    }

    func configure() {
        durationLabel.font = durationLabel.font.withSize(36)
        durationLabel.textColor = .black
        durationLabel.text = Double(self.viewModel.trip.duration).formatSecondDuration()
        
        DriverDataStyle.applyTripDarkGrey(label: timeSlotLabel)
        timeSlotLabel.text = self.viewModel.timeSlotLabelText
        
        messageBackGround.backgroundColor = DKUIColors.warningColor.color
        messageBackGround.layer.cornerRadius = 4
        messageBackGround.layer.masksToBounds = true
        
        messageImage.image = UIImage(named: "dk_info", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        messageImage.tintColor = DKUIColors.warningColor.color
        messageLabel.text = "dk_trip_detail_no_score".dkDriverDataLocalized()
        messageLabel.font = messageLabel.font.withSize(14)
        messageLabel.textColor = .white
    }

}
