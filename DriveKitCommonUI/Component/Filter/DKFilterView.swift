//
//  DKFilterView.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 30/09/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

final public class DKFilterView: UIView, Nibable {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pickerImage: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(viewModel : DKFilterViewModel) {
        self.pickerImage.isHidden = viewModel.showPicker
        self.name.attributedText = viewModel.getName().dkAttributedString().color(.mainFontColor).font(dkFont: .primary, style: .normalText).build()
        if let itemImage = viewModel.getImage() {
            self.image.image = itemImage
            self.image.layer.cornerRadius = self.image.frame.height / 2
            self.image.clipsToBounds = true
            self.image.isHidden = false
        } else {
            self.image.isHidden = true
        }
    }
}
