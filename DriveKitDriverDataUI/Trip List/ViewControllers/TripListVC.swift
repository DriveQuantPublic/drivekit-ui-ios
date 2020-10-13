//
//  TripListVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 03/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitTripAnalysisModule
import DriveKitCommonUI

public class TripListVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noTripsView: UIView!
    @IBOutlet var noTripsImage: UIImageView!
    @IBOutlet var noTripsLabel: UILabel!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var synthesis: UILabel!
    
    private let filterView = DKFilterView.viewFromNib
    private let refreshControl = UIRefreshControl()
    
    let viewModel: TripListViewModel
    var filterViewModel : DKFilterViewModel?
    
    public init() {
        self.viewModel = TripListViewModel()
        super.init(nibName: String(describing: TripListVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_driverdata_trips_list_title".dkDriverDataLocalized()
        self.tableView.register(TripTableViewCell.nib, forCellReuseIdentifier: "TripTableViewCell")
        if #available(iOS 11, *) {
          tableView.separatorInset = .zero
        }
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTripList(_ :)), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.delegate = nil
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.showLoader()
        self.viewModel.delegate = self
    }

    func updateUI() {
        if self.viewModel.status == .failedToSyncTripsCacheOnly {
            let alert = UIAlertController(title: nil, message: "dk_driverdata_failed_to_sync_trips".dkDriverDataLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.viewModel.filteredTrips.count > 0 {
            self.noTripsView.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.configureSynthesis()
        } else {
            self.noTripsView.isHidden = false
            self.tableView.isHidden = false
            if self.viewModel.hasTrips() {
                self.noTripsImage.image = UIImage(named: "dk_no_vehicle_trips", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withAlignmentRectInsets(UIEdgeInsets(top: -50, left: -50, bottom: -50,right:-50))
                self.noTripsLabel.text = "dk_driverdata_no_trip_placeholder".dkDriverDataLocalized()
            } else {
                self.noTripsImage.image = UIImage(named: "dk_no_trips_recorded", in: Bundle.driverDataUIBundle, compatibleWith: nil)
                self.noTripsLabel.text = "dk_driverdata_no_trips_recorded".dkDriverDataLocalized()
            }
            self.synthesis.isHidden = true
        }
        self.configureFilter()
    }
    
    private func configureFilter() {
        if let items = viewModel.getVehicleFilterItems(), items.count > 1 {
            self.filterViewContainer.isHidden = false
            if filterView.superview == nil {
                self.filterViewModel = DKFilterViewModel(items: items, currentItem: items[0], showPicker: true, delegate: self)
                self.filterViewContainer.embedSubview(filterView)
            }
            filterView.configure(viewModel: self.filterViewModel!, parentViewController: self)
        } else {
            self.filterViewContainer.isHidden = true
        }
    }
    
    private func configureSynthesis() {
        self.synthesis.isHidden = false
        let tripNumber = viewModel.tripNumber
        let synthesisText = "%@ \(tripNumber > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()) - %@ \(DKCommonLocalizable.unitKilometer.text())"
        let tripNumberValue = String(tripNumber).dkAttributedString().color(.primaryColor).font(dkFont: .secondary, style: .highlightSmall).build()
        let distanceValue = String(format: "%.0f", viewModel.tripsDistance).dkAttributedString().color(.primaryColor).font(dkFont: .secondary, style: .highlightSmall).build()
        self.synthesis.attributedText = synthesisText.dkAttributedString().color(.mainFontColor).font(dkFont: .secondary, style: .normalText).buildWithArgs(tripNumberValue, distanceValue)
    }

    @objc func refreshTripList(_ sender: Any) {
        self.viewModel.fetchTrips()
        DriveKitTripAnalysis.shared.checkTripToRepost()
    }

}

extension TripListVC : TripsDelegate {
    func onTripsAvailable() {
        DispatchQueue.main.async {
            self.hideLoader()
            self.updateUI()
        }
    }
}

extension TripListVC : DKFilterItemDelegate {
    public func onFilterItemSelected() {
        var vehicleId : String? = nil
        if let itemId = self.filterViewModel?.getCurrentItemId(), itemId is String {
            vehicleId = itemId as? String
        }
        self.viewModel.filterTrips(vehicleId: vehicleId)
        self.updateUI()
        self.tableView.reloadData()
    }
}
