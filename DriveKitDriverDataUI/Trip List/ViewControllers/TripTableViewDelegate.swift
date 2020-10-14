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
            cell.configure(trip: self.viewModel.filteredTrips[indexPath.section].trips[indexPath.row])
            if let adviceButton = cell.adviceButton {
                adviceButton.addTarget(self, action: #selector(openTips), for: .touchUpInside)
            } else if let adviceCountView = cell.adviceCountView {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openSelectedTips(_:)))
                adviceCountView.addGestureRecognizer(gestureRecognizer)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func openTips(sender: AdviceButton){
        let tripDetail = TripDetailVC(itinId: sender.trip.itinId!, showAdvice: true)
        self.navigationController?.pushViewController(tripDetail, animated: true)
    }

    @objc func openSelectedTips(_ sender: UITapGestureRecognizer) {
        if let adviceCountView = sender.view as? AdviceCountView, let trip = adviceCountView.trip {
            let tripDetail = TripDetailVC(itinId: trip.itinId!, showAdvice: true)
            self.navigationController?.pushViewController(tripDetail, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripDetail = TripDetailVC(itinId: self.viewModel.filteredTrips[indexPath.section].trips[indexPath.row].itinId!, showAdvice: false)
        self.navigationController?.pushViewController(tripDetail, animated: true)
    }
}
