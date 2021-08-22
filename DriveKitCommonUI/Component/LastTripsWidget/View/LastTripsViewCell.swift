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
    }

    override func prepareForReuse() {
        self.tripCell?.prepareForReuse()
    }

}
