// swiftlint:disable no_magic_numbers
//
//  DKFilterTableViewCell.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 01/10/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class DKFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemImage.tintColor = .black
        self.itemImage.clipsToBounds = true

        self.roundCorners(clipping: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.itemImage.layer.cornerRadius = self.itemImage.bounds.height / 2
    }
    
    func configure(viewModel: DKFilterViewModel, position: Int) {
        if let image = viewModel.getImageAt(position) {
            self.itemImage.image = image
            self.itemImage.isHidden = false
            self.imageWidthConstraint.constant = 60
        } else {
            self.itemImage.image = nil
            self.itemImage.isHidden = true
            self.imageWidthConstraint.constant = 0
        }
        
        self.name.attributedText = viewModel.getNameAt(position).dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .normalText).build()
    }
}
