////
////  ReferenceTableViewCell.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 09/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//
//final class ReferenceTableViewCell: UITableViewCell, Nibable {
//    @IBOutlet weak var referenceImage: UIImageView!
//    @IBOutlet weak var referenceLabel: UILabel!
//    @IBOutlet weak var referenceDate: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.configure()
//    }
//    
//    func configure(){
//        self.referenceImage.image = UIImage(named: "speedometer")?.withRenderingMode(.alwaysTemplate)
//        self.referenceImage.tintColor = UIColor.secondary_text
//        self.referenceLabel.font = DQConfiguration.primaryBoldFont(20)
//        self.referenceLabel.textColor = UIColor.secondary_text
//        self.referenceDate.font = DQConfiguration.primaryFont(11)
//        self.referenceDate.textColor = UIColor.secondary_text
//    }
//}
