//
//  LastTripsViewCell.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 20/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class LastTripsViewCell : UICollectionViewCell, Nibable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tripCellContainer: UIView!
    private weak var tripCell: TripTableViewCell!
    var tripInfoView: TripInfoView? {
        return tripCell?.tripInfoView
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tripCell = TripTableViewCell.viewFromNib
        tripCell.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tripCell.frame = self.tripCellContainer.bounds
        tripCell.selectionStyle = .none
        tripCell.isUserInteractionEnabled = false
        self.tripCellContainer.addSubview(tripCell)
        self.tripCell = tripCell
    }

    func configure(trip: DKTripListItem, tripData: TripData, title: String) {
        self.titleLabel.attributedText = title.dkAttributedString().font(dkFont: .primary, style: DKStyles.highlightSmall.withSizeDelta(-2)).color(.complementaryFontColor).build()
        self.tripCell?.configure(trip: trip, tripData: tripData)
        if let tripInfoView = tripInfoView, let tripCell = self.tripCell {
            tripCell.accessoryView = nil
            self.addSubview(tripInfoView)
            tripInfoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: tripInfoView, attribute: .centerY, relatedBy: .equal, toItem: tripCell, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tripInfoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
                NSLayoutConstraint(item: tripInfoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32),
                NSLayoutConstraint(item: tripCell, attribute: .trailing, relatedBy: .equal, toItem: tripInfoView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self, attribute: .trailingMargin, relatedBy: .equal, toItem: tripInfoView, attribute: .trailingMargin, multiplier: 1, constant: 8)
            ])
        }
    }

    override func prepareForReuse() {
        tripInfoView?.removeFromSuperview()
        self.tripCell?.prepareForReuse()
    }

}
