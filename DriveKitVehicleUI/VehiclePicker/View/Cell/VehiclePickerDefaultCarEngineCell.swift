// swiftlint:disable no_magic_numbers
//
//  VehiclePickerDefaultCarEngineCell.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 13/12/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerDefaultCarEngineCell: UITableViewCell {

    static let reuseIdentifier = "VehiclePickerDefaultCarEngineCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupStyle() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    func updateStyle(selected: Bool) {
        if selected {
            self.imageView?.image = UIImage.circleIcon(
                diameter: 30.0,
                borderColor: DKUIColors.secondaryColor.color,
                insideColor: DKUIColors.secondaryColor.color,
                insideRadius: 6
            )
            self.textLabel?.textColor = DKUIColors.secondaryColor.color
        } else {
            self.imageView?.image = UIImage.circleIcon(
                diameter: 30.0,
                borderColor: UIColor.black,
                insideColor: UIColor.clear
            )
            self.textLabel?.textColor = .black
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateStyle(selected: selected)
    }

//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        updateStyle(selected: highlighted)
//    }
}
