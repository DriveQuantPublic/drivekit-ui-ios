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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemImage.tintColor = .black
        self.itemImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.itemImage.layer.cornerRadius = self.itemImage.bounds.height / 2
    }
    
    func configure(viewModel : DKFilterViewModel, position: Int) {
        self.itemImage.image = viewModel.getImageAt(position)
        self.name.attributedText = viewModel.getNameAt(position).dkAttributedString().color(.complementaryFontColor).font(dkFont: .secondary, style: .normalText).build()
    }
}
