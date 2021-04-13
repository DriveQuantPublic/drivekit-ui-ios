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
        if let tripList = viewModel?.tripList, tripList.canSwipeToRefresh() {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: #selector(refreshTripList(_ :)), for: .valueChanged)
        }
    }

    public init(viewModel: TripsListViewModel) {
        super.init(style: .plain)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func refreshTripList(_ sender: Any) {
        if let tripList = viewModel?.tripList {
            tripList.onSwipeToRefresh()
        }
    }

    // MARK: - Table view delegate
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let header = HeaderDayView.viewFromNib
        if let headerDay = viewModel?.tripList?.getHeaderDay(), let tripsByDate = viewModel?.tripList?.getTripsList()[section], let tripsListItems: [TripsListItem] = tripsByDate.trips as? [TripsListItem] {
            header.configure(trips: tripsListItems, date: tripsByDate.date, headerDay: headerDay, dkHeader: viewModel?.tripList?.getCustomHeader())
        }
        return header
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.tripList?.getTripsList().count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.tripList?.getTripsList()[section].trips.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: TripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TripTableViewCell") as? TripTableViewCell {
            if let trip = self.viewModel?.tripList?.getTripsList()[indexPath.section].trips[indexPath.row] {
                cell.selectionStyle = .none
                cell.configure(trip: trip, tripData: self.viewModel?.tripList?.getTripData() ?? .safety)
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
        if let tripInfoView = sender.view as? TripInfoView, let tripItem = tripInfoView.trip {
            if tripItem.hasInfoActionConfigured() {
                tripItem.infoClickAction(parentViewController: self)
            } else {
                self.viewModel?.tripList?.onTripClickListener(itinId: tripItem.getItinId())
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trip = self.viewModel?.tripList?.getTripsList()[indexPath.section].trips[indexPath.row] {
            self.viewModel?.tripList?.onTripClickListener(itinId: trip.getItinId())
        }
    }    
}
