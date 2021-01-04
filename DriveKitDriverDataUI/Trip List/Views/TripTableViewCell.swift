//
//  TripTableViewCell.swift
//  drivekit-test-app
//
//  Created by Jérémy Bayle on 20/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitCommonUI

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
    
    func configure(trip: Trip, tripInfo: DKTripInfo?, listConfiguration: TripListConfiguration){
        tripLineView.color = DKUIColors.secondaryColor.color
        configureLabels(trip: trip)
        configureTripData(trip: trip, listConfiguration: listConfiguration)
        if let tripInfo = tripInfo {
            configureTripInfo(trip: trip, tripInfo: tripInfo)
        }
    }
    
    private func configureLabels(trip: Trip) {
        self.departureHourLabel.attributedText = trip.startDate?.format(pattern: .hourMinuteLetter).dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(self.timeColor).build()
        self.arrivalHourLabel.attributedText = trip.endDate?.format(pattern: .hourMinuteLetter).dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(self.timeColor).build()

        self.departureCityLabel.attributedText = (trip.departureCity ?? "").dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.arrivalCityLabel.attributedText = (trip.arrivalCity ?? "").dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
    }
    
    private func configureTripData(trip: Trip, listConfiguration: TripListConfiguration){
        switch listConfiguration {
            case .motorized(_):
                configureMotorizedTripData(trip: trip)
            case .alternative(_):
                configureAlternativeTripData(trip: trip)
        }
    }
    
    private func configureMotorizedTripData(trip: Trip) {
        switch DriveKitDriverDataUI.shared.tripData.displayType() {
        case .gauge:
            if DriveKitDriverDataUI.shared.tripData.isScored(trip: trip) {
                let score = CircularProgressView.viewFromNib
                let scoreType: ScoreType = ScoreType(rawValue: DriveKitDriverDataUI.shared.tripData.rawValue) ?? .safety
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
            label.text = DriveKitDriverDataUI.shared.tripData.stringValue(trip: trip)
            label.font = DKStyle(size: DKStyles.smallText.style.size, traits: .traitBold).applyTo(font: .primary)
            label.textColor = DKUIColors.secondaryColor.color
            label.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            label.center = dataView.center
            label.textAlignment = .center
            dataView.embedSubview(label)
        }
    }
    
    private func configureAlternativeTripData(trip: Trip) {
        let view = AlternativeTripImageView.viewFromNib
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = TransportationMode(rawValue: Int(trip.declaredTransportationMode?.transportationMode ?? trip.transportationMode))?.getImage()
        dataView.embedSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: dataView.widthAnchor),
            view.heightAnchor.constraint(equalTo: dataView.heightAnchor),
            view.centerXAnchor.constraint(equalTo: dataView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: dataView.centerYAnchor)
        ])
    }
    
    private func configureTripInfo(trip: Trip, tripInfo: DKTripInfo){
        if tripInfo.isDisplayable(trip: trip) {
            tripInfoView = TripInfoView.viewFromNib
            tripInfoView?.setTrip(trip: trip)
            tripInfoView?.tripInfo = tripInfo
            tripInfoView?.setText(tripInfo.text(trip: trip) ?? "")
            if let image = tripInfo.image(trip: trip)?.withRenderingMode(.alwaysTemplate) {
                tripInfoView?.image.image = image
                tripInfoView?.image.tintColor = DKUIColors.fontColorOnSecondaryColor.color
            }
            tripInfoView?.backgroundColor = DKUIColors.secondaryColor.color
            tripInfoView?.layer.cornerRadius = 5
            tripInfoView?.layer.masksToBounds = true
            accessoryView = tripInfoView
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataView.subviews.forEach({  $0.removeFromSuperview() })
        accessoryView = nil
        tripInfoView = nil
    }
}
