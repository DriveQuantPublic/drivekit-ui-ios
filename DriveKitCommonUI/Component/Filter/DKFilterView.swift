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
    @IBOutlet weak var cardView: CardView!
    
    var viewModel: DKFilterViewModel!
    weak var parentViewController: UIViewController?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.image {
            let half = 0.5
            imageView.layer.cornerRadius = imageView.frame.height * half
        }
    }

    public func configure(viewModel: DKFilterViewModel, parentViewController: UIViewController) {
        self.viewModel = viewModel
        self.parentViewController = parentViewController
        self.pickerImage.isHidden = !viewModel.showPicker
        self.pickerImage.tintColor = DKUIColors.mainFontColor.color
        self.name.attributedText = viewModel.getName().dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .normalText).build()
        if let itemImage = viewModel.getImage() {
            self.image.image = itemImage
            self.image.clipsToBounds = true
            self.image.isHidden = false
        } else {
            self.image.isHidden = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.cardView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let vehiclePicker = DKFilterPickerVC(viewModel: viewModel)
        self.parentViewController?.present(vehiclePicker, animated: true)
    }
}
