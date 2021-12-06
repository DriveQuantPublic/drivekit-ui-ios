//
//  OdometerCell.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 05/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBVehicleAccessModule

protocol OdometerCellDelegate: AnyObject {
    func didTouchActionButton(sender: OdometerCell)
}

final class OdometerCell: UITableViewCell, Nibable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var subtitleValue: UILabel!
    @IBOutlet private weak var actionButton: UIButton!

    weak var delegate: OdometerCellDelegate?
    private var viewModel: OdometerCellViewModel?
    private var type: OdometerCellType = .odometer
    private var actionType: OdometerCellActionType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.actionButton.tintColor = DKUIColors.secondaryColor.color
    }

    func configure(viewModel: OdometerCellViewModel, type: OdometerCellType, actionType: OdometerCellActionType) {
        self.viewModel = viewModel
        self.type = type
        self.actionType = actionType
        self.configureTitle(viewModel: viewModel, type: type)
        self.configureOptionButton(actionType: actionType)
        self.configureContent(viewModel: viewModel, type: type)
    }

    private func configureTitle(viewModel: OdometerCellViewModel, type: OdometerCellType) {
        self.titleLabel.attributedText = viewModel.getTitle(type: type).dkAttributedString().color(.mainFontColor).font(dkFont: .primary, style: .normalText).build()
    }

    private func configureOptionButton(actionType: OdometerCellActionType) {
        let image: UIImage?
        switch actionType {
            case .option:
                image = DKImages.dots.image
            case .info:
                image = DKImages.info.image
            case .none:
                image = nil
        }
        if let image = image {
            self.actionButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            self.actionButton.isHidden = false
        } else {
            self.actionButton.isHidden = true
        }
    }

    private func configureContent(viewModel: OdometerCellViewModel, type: OdometerCellType) {
        self.valueLabel.attributedText = viewModel.getDistance(type: type).dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: DKStyle(size: 34, traits: .traitBold)).build()
        self.subtitleValue.attributedText = viewModel.getDescription(type: type).dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .smallText).build()
    }
    
    @IBAction private func touchActionButton(_ sender: Any) {
        switch self.actionType {
            case .option:
                self.delegate?.didTouchActionButton(sender: self)
            case .info:
                if let viewModel = self.viewModel {
                    let (title, message) = viewModel.getInfoContent(type: self.type)
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel))
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            case .none:
                break
        }
    }
}
