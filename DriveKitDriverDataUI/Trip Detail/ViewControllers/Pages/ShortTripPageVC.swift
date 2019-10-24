//
//  ShortTripPageVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 18/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

class ShortTripPageVC: UIViewController {
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var timeSlotLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var messageBackGround: UIView!
    
    var viewModel: ShortTripPageViewModel
    var detailConfig : TripDetailViewConfig
    
    init(viewModel: ShortTripPageViewModel, detailConfig: TripDetailViewConfig) {
        self.viewModel = viewModel
        self.detailConfig = detailConfig
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
        durationLabel.font = durationLabel.font.bold.withSize(36)
        durationLabel.textColor = .black
        durationLabel.text = self.viewModel.trip.formattedDuration
        
        DriverDataStyle.applyTripDarkGrey(label: timeSlotLabel)
        timeSlotLabel.text = self.viewModel.timeSlotLabelText
        
        messageBackGround.backgroundColor = .dkWarning
        messageBackGround.layer.cornerRadius = 4
        messageBackGround.layer.masksToBounds = true
        
        messageImage.image = UIImage(named: "dk_info", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        messageImage.tintColor = .dkWarning
        messageLabel.text = detailConfig.noScoreText
        messageLabel.font = messageLabel.font.withSize(14)
        messageLabel.textColor = .white
    }

}
