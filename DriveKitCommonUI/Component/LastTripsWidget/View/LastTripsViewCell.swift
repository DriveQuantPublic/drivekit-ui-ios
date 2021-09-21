//
//  LastTripsViewCell.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 20/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

final class LastTripsViewCell : UICollectionViewCell, Nibable {

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
        self.tripCell?.configure(trip: trip, tripData: tripData, isFirst: true, separatorColor: nil)
        if let tripInfoView = tripInfoView, let tripCell = self.tripCell {
            tripCell.accessoryView = nil
            self.addSubview(tripInfoView)
            tripInfoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tripInfoView.centerYAnchor.constraint(equalTo: tripCell.centerYAnchor),
                tripInfoView.widthAnchor.constraint(equalToConstant: 50),
                tripInfoView.heightAnchor.constraint(equalToConstant: 32),
                tripCell.trailingAnchor.constraint(equalTo: tripInfoView.leadingAnchor),
                NSLayoutConstraint(item: self, attribute: .trailingMargin, relatedBy: .equal, toItem: tripInfoView, attribute: .trailingMargin, multiplier: 1, constant: 8)
            ])
        }
    }

    override func prepareForReuse() {
        tripInfoView?.removeFromSuperview()
        self.tripCell?.prepareForReuse()
    }

}
