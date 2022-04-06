//
//  TripListVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 03/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBTripAccessModule

public class TripListVC: DKUIViewController {
    @IBOutlet weak var tripsStackView: UIStackView!
    weak var tripsTableView: UITableView?
    @IBOutlet var noTripsView: UIView!
    @IBOutlet var noTripsImage: UIImageView!
    @IBOutlet var noTripsLabel: UILabel!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var synthesis: UILabel!
    @IBOutlet weak var tripsViewPlaceholder: UIView!

    private let filterView = DKFilterView.viewFromNib
    
    let viewModel: TripListViewModel
    var tripListTableViewModel: DKTripListViewModel?
    private var filterViewModel: DKFilterViewModel?
    private var updating = false

    public init() {
        self.viewModel = TripListViewModel()
        super.init(nibName: String(describing: TripListVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "dk_driverdata_trips_list_title".dkDriverDataLocalized()
        tripListTableViewModel = DKTripListViewModel(tripList: self)
        let tripsListTableVC = TripsListTableVC<Trip>(viewModel: tripListTableViewModel!)
        self.addChild(tripsListTableVC)
        if let tripsTableView = tripsListTableVC.tableView {
            self.tripsTableView = tripsTableView
            self.tripsStackView.addArrangedSubview(tripsTableView)
        }

        self.updating = true
        self.showLoader()
        self.viewModel.delegate = self
    }

    override public func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchTrips(withSynchronizationType: .cache)
        if self.viewModel.showFilter(), let items = self.viewModel.getTripFilterItem(), items.count > 1 {
            self.filterViewModel?.updateItems(items: items)
        }
    }

    func update() {
        if !self.updating {
            self.updating = true
            self.showLoader()
            self.viewModel.fetchTrips(withSynchronizationType: .cache)
        }
    }
    
    private func configureFilterButton() {
        if DriveKitDriverDataUI.shared.enableAlternativeTrips && self.viewModel.hasAlternativeTrips() {
            let image = UIImage(named: "dk_filter", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
            let filterButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filterAction))
            filterButton.tintColor = DKUIColors.navBarElementColor.color
            self.navigationItem.rightBarButtonItem = filterButton
        }
    }
    
    @objc private func filterAction() {
        let items = viewModel.getTripListFilterItems()
        if items.count > 1 {
            let pickerViewModel = DKFilterViewModel(items: items, currentItem: items[0], showPicker: true, delegate: self)
            let tripListConfigurationPicker = DKFilterPickerVC(viewModel: pickerViewModel)
            self.present(tripListConfigurationPicker, animated: true)
        }
    }

    func updateUI() {
        if self.viewModel.status == .failedToSyncTripsCacheOnly {
            let alert = UIAlertController(title: nil, message: "dk_driverdata_failed_to_sync_trips".dkDriverDataLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                if let refreshControl = self.tripsTableView?.refreshControl, refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.viewModel.filteredTrips.count > 0 {
            self.noTripsView.isHidden = true
            self.tripsTableView?.isHidden = false
            self.tripsViewPlaceholder?.isHidden = true
            self.tripsTableView?.reloadData()
            if let refreshControl = self.tripsTableView?.refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            self.configureSynthesis()
        } else {
            self.noTripsView.isHidden = false
            self.tripsTableView?.isHidden = true
            self.tripsViewPlaceholder?.isHidden = false
            if self.viewModel.hasTrips() {
                self.noTripsImage.image = UIImage(named: "dk_no_vehicle_trips", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withAlignmentRectInsets(UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50))
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
        if self.viewModel.showFilter(), let items = viewModel.getTripFilterItem(), items.count > 1, self.viewModel.hasTrips() {
            self.filterViewContainer.isHidden = false
            if filterView.superview == nil {
                self.filterViewModel = DKFilterViewModel(items: items, currentItem: items[0], showPicker: true, delegate: self)
                self.filterViewContainer.embedSubview(filterView)
            }
            filterView.configure(viewModel: filterViewModel!, parentViewController: self)
        } else {
            self.filterViewContainer.isHidden = true
        }
    }
    
    private func configureSynthesis() {
        if self.viewModel.showFilter() {
            self.synthesis.isHidden = false
            let tripNumber = viewModel.tripNumber
            let synthesisText = "%@ \(tripNumber > 1 ? DKCommonLocalizable.tripPlural.text() : DKCommonLocalizable.tripSingular.text()) - %@ \(DKCommonLocalizable.unitKilometer.text())"
            let tripNumberValue = String(tripNumber).dkAttributedString().color(.primaryColor).font(dkFont: .primary, style: .highlightSmall).build()
            let distanceValue = viewModel.tripsDistance.formatMeterDistanceInKm(appendingUnit: false).dkAttributedString().color(.primaryColor).font(dkFont: .primary, style: .highlightSmall).build()
            self.synthesis.attributedText = synthesisText.dkAttributedString().color(.complementaryFontColor).font(dkFont: .primary, style: .driverDataText).buildWithArgs(tripNumberValue, distanceValue)
        } else {
            self.synthesis.isHidden = true
        }
    }
}

extension TripListVC: TripsDelegate {
    func onTripsAvailable() {
        DispatchQueue.main.async {
            self.hideLoader()
            self.updateUI()
            self.configureFilterButton()
            self.tripsTableView?.reloadData()
            self.updating = false
        }
    }
}

extension TripListVC: DKFilterItemDelegate {
    public func onFilterItemSelected(filterItem: DKFilterItem) {
        if filterItem.getId() is TripListConfiguration{
            tripListFilterItemSelected(filterItem: filterItem)
        } else if filterItem.getId() is TransportationMode  || filterItem.getId() is AllAlternativeMode{
            transportationModeFilterItemSelected(filterItem: filterItem)
        } else {
           vehicleFilterItemSelected(filterItem: filterItem)
        }
    }
    
    private func vehicleFilterItemSelected(filterItem: DKFilterItem) {
        var vehicleId: String? = nil
        if let itemId = filterItem.getId() as? String {
            vehicleId = itemId
        }
        self.viewModel.filterTrips(config: .motorized(vehicleId: vehicleId))
        self.updateUI()
        self.tripsTableView?.reloadData()
    }
    
    private func tripListFilterItemSelected(filterItem: DKFilterItem) {
        if let tripListConfiguration = filterItem.getId() as? TripListConfiguration, tripListConfiguration.identifier() != self.viewModel.listConfiguration.identifier() {
            switch tripListConfiguration  {
                case .motorized:
                    self.viewModel.filterTrips(config: .motorized())
                case .alternative:
                    self.viewModel.filterTrips(config: .alternative())
            }
            if let items = viewModel.getTripFilterItem(), items.count > 1 {
                self.filterViewModel = DKFilterViewModel(items: items, currentItem: items[0], showPicker: true, delegate: self)
            }
            self.updateUI()
            self.tripsTableView?.reloadData()
        }
    }
    
    private func transportationModeFilterItemSelected(filterItem: DKFilterItem) {
        let mode = filterItem.getId() as? TransportationMode
        self.viewModel.filterTrips(config: .alternative(transportationMode: mode))
        self.updateUI()
        self.tripsTableView?.reloadData()
    }
}
