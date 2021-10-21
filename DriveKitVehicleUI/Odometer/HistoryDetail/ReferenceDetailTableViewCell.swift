////
////  ReferenceDetailTableViewCell.swift
////  DriveKitVehicleUI
////
////  Created by Meryl Barantal on 09/08/2019.
////  Copyright © 2019 DriveQuant. All rights reserved.
////
//
//import UIKit
//import DriveKitDBVehicleAccessModule
//
//protocol ReferenceDelegate : AnyObject {
//    func didUpdateDistanceField(distance: Double, sender: ReferenceDetailTableViewCell)
//}
//
//final class ReferenceDetailTableViewCell: UITableViewCell, Nibable {
//    
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var textFieldSubtitle: UILabel!
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var cellImage: UIImageView!
//    
//    weak var delegate : ReferenceDelegate?
//    var distanceUpdated: Double = 0
//    var defaultDistance: Double = 0
//    
//    func configure(type: ReferenceCellType, value: String?, vehicle: DKVehicle, history : DKVehicleOdometerHistory?) {
//        self.defaultDistance = history?.distance ?? 0
//        textField.isHidden = true
//        textField.font = DQConfiguration.primaryFont(14)
//        textField.textColor = UIColor.secondary_text
//        label.isHidden = true
//        label.font = DQConfiguration.primaryFont(14)
//        label.textColor = UIColor.secondary_text
//        textFieldSubtitle.isHidden = true
//        switch type {
//        case .distance:
//            textField.keyboardType = .numberPad
//            textField.isHidden = false
//            textField.placeholder = type.placeholder
//            if var text = value {
//                if text.isEmpty {
////                    text = "0" + " " + "distance_unit".keyLocalized()
//                    defaultDistance = 0
//                } else {
//                    text = text + " " + "distance_unit".keyLocalized()
//                }
//                textField.text = text
//            }
//            cellImage.image = type.image?.withRenderingMode(.alwaysTemplate)
//            cellImage.tintColor = .black
//        case .date:
//            label.isHidden = false
//            let dateFormatter = DateFormatter.isoDate
//            if let date = dateFormatter.date(from: value ?? "") {
//                label.text = date.dayWithYear
//            } else {
//                label.text = Date().dayWithYear
//            }
//            cellImage.image = type.image?.withRenderingMode(.alwaysTemplate)
//            cellImage.tintColor = .black
//        case .vehicle(_):
//            label.isHidden = false
//            cellImage.layer.cornerRadius = cellImage.frame.height/2
//            label.text = value
//            cellImage.image = type.image
//            cellImage.tintColor = .none
//        }
//    }
//    
//    @IBAction func didEndEditing(_ sender: Any) {
//        editingChanged(sender)
//        if let text = textField.text{
//            textField.text = text + " " + "distance_unit".keyLocalized()
//        }
//    }
//
//    @IBAction func editingChanged(_ sender: Any) {
//        if let text = textField.text, let value = Double(text) {
//            self.distanceUpdated = value
//            if value >= 0 && value <= 1000000 {
//                textFieldSubtitle.isHidden = true
//                self.didUpdateDistanceField(distance: value)
//            } else {
//                subtitleError(text: "error_odometer".keyLocalized())
//            }
//        } else {
//            subtitleError(text: "error_numeric".keyLocalized())
//        }
//    }
//    
//    func subtitleError(text: String) {
//        textFieldSubtitle.isHidden = false
//        textFieldSubtitle.text = text
//        textFieldSubtitle.font = DQConfiguration.primaryFont(10)
//        textFieldSubtitle.textColor = .warning
//    }
//    
//    func didUpdateDistanceField(distance: Double) {
//        delegate?.didUpdateDistanceField(distance: distance, sender: self)
//    }
//    
//    @IBAction func didEnterDistanceField(_ sender: Any) {
//        if distanceUpdated > 0 {
//            textField.text = String(format: "%.0f", distanceUpdated)
//        } else {
//            if defaultDistance == 0 {
//                textField.text = ""
//            } else {
//                textField.text = String(format: "%.0f", defaultDistance)
//            }
//        }
//    }
//}
