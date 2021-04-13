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
    
    private let filterView = DKFilterView.viewFromNib
    private let refreshControl = UIRefreshControl()
    
    let viewModel: TripListViewModel
    var tripsListTableViewModel: TripsListViewModel?
    private var filterViewModel : DKFilterViewModel?
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
        tripsListTableViewModel = TripsListViewModel(tripsByDate: self.viewModel.filteredTrips, headerDay: DriveKitDriverDataUI.shared.headerDay, dkHeader: DriveKitDriverDataUI.shared.customHeaders, tripData: DriveKitDriverDataUI.shared.tripData)
        let tripsListTableVC = TripsListTableVC<Trip>(viewModel: tripsListTableViewModel!)
        self.addChild(tripsListTableVC)
        if let tripsTableView = tripsListTableVC.tableView {
            self.tripsTableView = tripsTableView
            self.tripsStackView.addArrangedSubview(tripsTableView)
            tripsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshTripList(_ :)), for: .valueChanged)

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
    
    private func configureFilterButton(){
        if DriveKitDriverDataUI.shared.enableAlternativeTrips && self.viewModel.hasAlternativeTrips() {
            let image = UIImage(named: "dk_filter", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
            let filterButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filterAction))
            filterButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = filterButton
        }
    }
    
    @objc private func filterAction(){
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
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.viewModel.filteredTrips.count > 0 {
            self.noTripsView.isHidden = true
            self.tripsTableView?.isHidden = false
            self.tripsListTableViewModel?.updateTrips(tripsByDate: self.viewModel.filteredTrips)
            self.tripsTableView?.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.configureSynthesis()
        } else {
            self.noTripsView.isHidden = false
            if self.viewModel.hasTrips() {
                self.tripsTableView?.isHidden = false
                self.noTripsImage.image = UIImage(named: "dk_no_vehicle_trips", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withAlignmentRectInsets(UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50))
                self.noTripsLabel.text = "dk_driverdata_no_trip_placeholder".dkDriverDataLocalized()
            } else {
                self.tripsTableView?.isHidden = true
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

    @objc func refreshTripList(_ sender: Any) {
        self.viewModel.fetchTrips()
        DriveKit.shared.modules.tripAnalysis?.checkTripToRepost()
    }

}

extension TripListVC : TripsDelegate {
    func onTripsAvailable() {
        DispatchQueue.main.async {
            self.hideLoader()
            self.updateUI()
            self.configureFilterButton()
            self.tripsListTableViewModel?.updateTrips(tripsByDate: self.viewModel.filteredTrips)
            self.tripsTableView?.reloadData()
            self.updating = false
        }
    }
}

extension TripListVC : DKFilterItemDelegate {
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
        self.tripsListTableViewModel?.updateTrips(tripsByDate: self.viewModel.filteredTrips)
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
            self.tripsListTableViewModel?.updateTrips(tripsByDate: self.viewModel.filteredTrips)
            self.tripsTableView?.reloadData()
        }
    }
    
    private func transportationModeFilterItemSelected(filterItem: DKFilterItem) {
        let mode = filterItem.getId() as? TransportationMode
        self.viewModel.filterTrips(config: .alternative(transportationMode: mode))
        self.updateUI()
        self.tripsListTableViewModel?.updateTrips(tripsByDate: self.viewModel.filteredTrips)
        self.tripsTableView?.reloadData()
    }
}

extension TripListVC {
    private func showTripDetail(itinId : String) {
        if let navigationController = self.navigationController {
            let tripDetail = TripDetailVC(itinId: itinId, showAdvice: false, listConfiguration: self.viewModel.listConfiguration)
            navigationController.pushViewController(tripDetail, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
        }
    }
}

// TODO: complete implementation
extension Trip: DKTripsListItem {    
    public func getItinId() -> String {
        return self.itinId ?? ""
    }
    public func getDuration() -> Double {
        return Double(self.duration)
    }
    public func getDistance() -> Double? {
        return self.tripStatistics?.distance
    }
    public func getStartDate() -> Date? {
        return self.startDate
    }
    public func getEndDate() -> Date {
        return self.endDate ?? Date()
    }
    public func getDepartureCity() -> String? {
        return self.departureCity
    }
    public func getArrivalCity() -> String? {
        return self.arrivalCity
    }

    public func isScored(tripData: TripData) -> Bool {
        switch tripData {
        case .safety, .ecoDriving:
            return !self.unscored
        case .distraction:
            if !self.unscored, let score = self.driverDistraction?.score {
                return score <= 10
            }
            return false
        case .speeding:
            if !self.unscored, let score = self.speedingStatistics?.score {
                return score <= 10
            }
            return false
        case .distance, .duration:
            return true
        }
    }

    public func getScore(tripData: TripData) -> Double? {
        switch tripData {
        case .ecoDriving:
            return self.ecoDriving?.score ?? 0
        case .safety:
            return  self.safety?.safetyScore ?? 0
        case .distraction:
            return self.driverDistraction?.score ?? 0
        case .speeding:
            return self.speedingStatistics?.score ?? 0
        case .distance:
            return self.getDistance() ?? 0
        case .duration:
            return self.getDuration()
        }
    }

    public func getScoreText(tripData: TripData) -> String? {
        return nil
    }

    public func getTransportationModeResource() -> UIImage? {
        return TransportationMode(rawValue: Int(self.declaredTransportationMode?.transportationMode ?? self.transportationMode))?.getImage()
    }

    public func isAlternative() -> Bool {
        if let transportationMode = TransportationMode(rawValue: Int(self.declaredTransportationMode?.transportationMode ?? self.transportationMode)) {
            return transportationMode.isAletrnative()
        }
        return false
    }

    public func getDisplayText() -> String {
        return ""
    }

    public func infoText() -> String? {
        guard let tripAdvices: Set<TripAdvice>  = self.tripAdvices as? Set<TripAdvice> else {
            return nil
        }
        if tripAdvices.count > 1 {
            return "\(tripAdvices.count)"
        } else {
            return nil
        }
    }

    public func infoImageResource() -> UIImage? {
        guard let tripAdvices: [TripAdvice]  = self.tripAdvices?.allObjects as? [TripAdvice] else {
            return nil
        }
        if tripAdvices.count > 1 {
            return UIImage(named: "dk_trip_info_count", in: Bundle.driverDataUIBundle, compatibleWith: nil)
        } else if tripAdvices.count == 1 {
            let advice = tripAdvices[0]
            return advice.adviceImage()
        } else {
            return nil
        }
    }

    public func infoClickAction(parentViewController: UIViewController) {
        let showAdvice = (self.tripAdvices as? Set<TripAdvice>)?.count ?? 0 > 0
        if let itinId = self.itinId {
            if let navigationController = parentViewController.navigationController {
                let tripDetail = TripDetailVC(itinId: itinId, showAdvice: showAdvice, listConfiguration: .motorized())
                navigationController.pushViewController(tripDetail, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DKShowTripDetail"), object: nil, userInfo: ["itinId": itinId])
            }
        }
    }

    public func hasInfoActionConfigured() -> Bool {
        return true
    }

    public func isInfoDisplayable() -> Bool {
        guard let tripAdvices: Set<TripAdvice>  = self.tripAdvices as? Set<TripAdvice> else {
            return false
        }
        return tripAdvices.count > 0
    }
}
