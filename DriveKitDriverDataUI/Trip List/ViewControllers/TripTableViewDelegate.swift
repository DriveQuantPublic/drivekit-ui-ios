//
//  TripTableViewDelegate.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 03/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

extension TripListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderDayView.viewFromNib
        header.configure(trips: self.viewModel.filteredTrips[section])
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
}

extension TripListVC : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.filteredTrips.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredTrips[section].trips.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : TripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell") as? TripTableViewCell {
            cell.selectionStyle = .none
            cell.configure(trip: self.viewModel.filteredTrips[indexPath.section].trips[indexPath.row], tripInfo: self.viewModel.getTripInfo())
            if let tripInfoView = cell.tripInfoView {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripInfoAction(_:)))
                tripInfoView.addGestureRecognizer(gestureRecognizer)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func tripInfoAction(_ sender: UITapGestureRecognizer) {
        if let tripInfoView = sender.view as? TripInfoView, let trip = tripInfoView.trip, let tripInfo = tripInfoView.tripInfo {
            if tripInfo.hasActionConfigured(trip: trip) {
                tripInfo.clickAction(trip: trip, parentViewController: self)
            } else {
                if let itinId = trip.itinId {
                    showTripDetail(itinId: itinId)
                }
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itinId = self.viewModel.filteredTrips[indexPath.section].trips[indexPath.row].itinId {
            showTripDetail(itinId: itinId)
        }
    }
    
    private func showTripDetail(itinId : String) {
        if let navigationController = self.navigationController {
            let tripDetail = TripDetailVC(itinId: itinId, showAdvice: false)
            navigationController.pushViewController(tripDetail, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
        }
    }
}
