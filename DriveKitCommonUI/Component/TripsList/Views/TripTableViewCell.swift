//
//  TripTableViewCell.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class TripTableViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var departureHourLabel: UILabel!
    @IBOutlet weak var arrivalHourLabel: UILabel!
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var arrivalCityLabel: UILabel!
    @IBOutlet weak var tripLineView: TripListSeparator!
    
    var tripInfoView: TripInfoView? = nil
    private let timeColor: UIColor = UIColor(hex: 0x9e9e9e)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(trip: DKTripsListItem, tripData: TripData) {
        tripLineView.color = DKUIColors.secondaryColor.color
        configureLabels(trip: trip)
        configureTripData(trip: trip, tripData: tripData)
        configureTripInfo(trip: trip)
    }
    
    private func configureLabels(trip: DKTripsListItem) {
        self.departureHourLabel.attributedText = trip.getStartDate()?.format(pattern: .hourMinuteLetter).dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(self.timeColor).build()
        self.arrivalHourLabel.attributedText = trip.getEndDate().format(pattern: .hourMinuteLetter).dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(self.timeColor).build()

        self.departureCityLabel.attributedText = (trip.getDepartureCity() ?? "").dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.arrivalCityLabel.attributedText = (trip.getArrivalCity() ?? "").dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
    }
    
    private func configureTripData(trip: DKTripsListItem, tripData: TripData) {
        if trip.isAlternative() {
            configureAlternativeTripData(trip: trip)
        } else {
            configureMotorizedTripData(trip: trip, tripData: tripData)
        }
    }
    
    private func configureMotorizedTripData(trip: DKTripsListItem, tripData: TripData) {
        switch tripData.displayType() {
        case .gauge:
            if trip.isScored(tripData: tripData) {
                let score = CircularProgressView.viewFromNib
                let scoreType: ScoreType = ScoreType(rawValue: tripData.rawValue) ?? .safety
                let configScore = ConfigurationCircularProgressView(scoreType: scoreType, value: scoreType.rawValue(trip: trip), size: .small)
                score.configure(configuration: configScore)
                score.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                score.center = dataView.center
                dataView.embedSubview(score)
            } else {
                let noScoreView = NoScoreImageView.viewFromNib
                noScoreView.translatesAutoresizingMaskIntoConstraints = false
                dataView.addSubview(noScoreView)
                NSLayoutConstraint.activate([
                    noScoreView.widthAnchor.constraint(equalTo: dataView.widthAnchor),
                    noScoreView.heightAnchor.constraint(equalTo: dataView.heightAnchor),
                    noScoreView.centerXAnchor.constraint(equalTo: dataView.centerXAnchor),
                    noScoreView.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)
                ])
            }
        case .text:
            let label = UILabel()
            label.text = tripData.stringValue(trip: trip)
            label.font = DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold).applyTo(font: .primary)
            label.textColor = DKUIColors.primaryColor.color
            label.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            label.center = dataView.center
            label.textAlignment = .center
            dataView.embedSubview(label)
        }
    }
    
    private func configureAlternativeTripData(trip: DKTripsListItem) {
        let view = AlternativeTripImageView.viewFromNib
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = trip.getTransportationModeResource()
        dataView.embedSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: dataView.widthAnchor),
            view.heightAnchor.constraint(equalTo: dataView.heightAnchor),
            view.centerXAnchor.constraint(equalTo: dataView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)
        ])
    }
    
    private func configureTripInfo(trip: DKTripsListItem) {
        if trip.isInfoDisplayable() {
            let tripInfoView = TripInfoView.viewFromNib
            tripInfoView.setTrip(trip: trip)
            let style: DKStyle
            if let image = trip.infoImageResource()?.withRenderingMode(.alwaysTemplate) {
                tripInfoView.image.image = image
                tripInfoView.image.tintColor = DKUIColors.fontColorOnSecondaryColor.color
                style = DKStyle(size: 10, traits: .traitBold)
            } else {
                style = DKStyles.normalText.withSizeDelta(-2)
            }
            tripInfoView.setText(trip.infoText() ?? "", style: style)
            tripInfoView.backgroundColor = DKUIColors.secondaryColor.color
            tripInfoView.layer.cornerRadius = 5
            tripInfoView.layer.masksToBounds = true
            accessoryView = tripInfoView
            self.tripInfoView = tripInfoView
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataView.subviews.forEach({  $0.removeFromSuperview() })
        accessoryView = nil
        tripInfoView = nil
    }
}
