////
////  OdometerButtonsTableViewCell.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 08/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//
//protocol OdometerButtonsTableViewCellDelegate : AnyObject {
//    func didSelectUpdateButton(sender: OdometerButtonsTableViewCell)
//    func didSelectReferenceLink(sender: OdometerButtonsTableViewCell)
//}
//
//final class OdometerButtonsTableViewCell: UITableViewCell, Nibable {
//    @IBOutlet weak var updateButton: CustomButton!
//    @IBOutlet weak var referenceLink: CustomButton!
//    
//    weak var delegate: OdometerButtonsTableViewCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        updateButton.customize(title: "update_odometer_title".keyLocalized().uppercased(), style: .full)
//        updateButton.titleLabel?.font = DQConfiguration.primaryBoldFont(14)
//        referenceLink.customize(title: "odometer_references_link".keyLocalized().uppercased(), style: .link)
//        referenceLink.titleLabel?.font = DQConfiguration.primaryFont(14)
//    }
//
//    @IBAction func selectUpdate(_ sender: Any) {
//        delegate?.didSelectUpdateButton(sender: self)
//    }
//    
//    @IBAction func selectReference(_ sender: Any) {
//        delegate?.didSelectReferenceLink(sender: self)
//    }
//}
