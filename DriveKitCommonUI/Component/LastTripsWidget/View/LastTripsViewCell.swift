//
//  LastTripsViewCell.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 20/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class LastTripsViewCell : UICollectionViewCell {

    private weak var tripCell: TripTableViewCell?
    var tripInfoView: TripInfoView? {
        return tripCell?.tripInfoView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tripCell = TripTableViewCell.viewFromNib
        tripCell.contentView.frame = self.contentView.bounds
        self.contentView.addSubview(tripCell)
        self.tripCell = tripCell
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(trip: DKTripListItem, tripData: TripData) {
        self.tripCell?.configure(trip: trip, tripData: tripData)
    }

    override func prepareForReuse() {
        self.tripCell?.prepareForReuse()
    }

}
