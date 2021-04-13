//
//  TripsListTableVC.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 12/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

public class TripsListTableVC<TripsListItem: DKTripsListItem>: UITableViewController {

    var viewModel: TripsListViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TripTableViewCell.nib, forCellReuseIdentifier: "TripTableViewCell")
        if #available(iOS 11, *) {
          tableView.separatorInset = .zero
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }

    public init(viewModel: TripsListViewModel) {
        super.init(style: .plain)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Table view delegate
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let header = HeaderDayView.viewFromNib
        if let headerDay = viewModel?.headerDay, let tripsByDate = viewModel?.tripsByDate[section], let tripsListItems: [TripsListItem] = tripsByDate.trips as? [TripsListItem] {
            header.configure(trips: tripsListItems, date: tripsByDate.date, headerDay: headerDay, dkHeader: viewModel?.dkHeader)
        }
        return header
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.tripsByDate.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.tripsByDate[section].trips.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: TripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell") as? TripTableViewCell {
            if let trip = self.viewModel?.tripsByDate[indexPath.section].trips[indexPath.row] {
            // TODO: uncomment and replace the following code
//            if !trip.isValid() {
//                self.update()
//            }
                cell.selectionStyle = .none
                cell.configure(trip: trip, tripData: self.viewModel?.tripData ?? .safety)
                if let tripInfoView = cell.tripInfoView {
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tripInfoAction(_:)))
                    tripInfoView.addGestureRecognizer(gestureRecognizer)
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func tripInfoAction(_ sender: UITapGestureRecognizer) {
        if let tripInfoView = sender.view as? TripInfoView, let trip = tripInfoView.trip, let tripItem = tripInfoView.trip {
            if tripItem.hasInfoActionConfigured() {
                tripItem.infoClickAction(parentViewController: self)
            } else {
                // TODO: uncomment and replace the following code
//                if let itinId = tripItem.getItinId() {
//                    showTripDetail(itinId: itinId)
//                } else if !trip.isValid() {
//                    self.update()
//                }
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = self.viewModel?.tripsByDate[indexPath.section].trips[indexPath.row]
        // TODO: uncomment and replace the following code
//        if trip.isValid() {
//            if let itinId = trip?.getItinId() {
//                showTripDetail(itinId: itinId)
//            }
//        } else {
//            self.update()
//        }
    }
    
}
