//
//  TripDetailVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import DriveKitCommonUI

class TripDetailVC: DKUIViewController {
    
    @IBOutlet var mapContainer: UIView!
    @IBOutlet var pageContainer: UIView!
    @IBOutlet var actionView: UIView!
    @IBOutlet var mapItemsView: UIStackView!
    @IBOutlet var mapItemViewConstraint: NSLayoutConstraint!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var headerContainer: UIView!
    @IBOutlet var tipButton: UIButton!
    
    var pageViewController: UIPageViewController!
    var viewModel: TripDetailViewModel
    var swipableViewControllers: [UIViewController] = []
    var mapViewController: MapViewController!
    var mapItemButtons: [UIButton] = []
    
    private var showAdvice : Bool
    
    
    init(itinId: String, showAdvice: Bool) {
        self.viewModel = TripDetailViewModel(itinId: itinId)
        self.showAdvice = showAdvice
        super.init(nibName: String(describing: TripDetailVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "dk_driverdata_trip_detail_title".dkDriverDataLocalized()
        showLoader()
        self.viewModel.delegate = self
        setupMapView()
        self.configureDeleteButton()
    }
    
    private func configureDeleteButton(){
        if DriveKitDriverDataUI.shared.enableDeleteTrip {
            let image = UIImage(named: "dk_delete_trip", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
            let deleteButton = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(deleteTrip))
            deleteButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc private func deleteTrip(){
        let alert = UIAlertController(title: "", message: "dk_driverdata_confirm_delete_trip".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { action in
            self.showLoader()
            DriveKitDriverData.shared.deleteTrip(itinId: self.viewModel.itinId, completionHandler: {deleteSuccessful in
                DispatchQueue.main.async {
                    self.hideLoader()
                    if deleteSuccessful {
                        self.showSuccessDelete()
                    }else{
                        self.showErrorDelete()
                    }
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorDelete() {
        let alert = UIAlertController(title: "", message: "dk_driverdata_failed_to_delete_trip".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessDelete() {
        let alert = UIAlertController(title: "", message: "dk_driverdata_trip_deleted".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TripDetailVC {
    
    func updateViewToCurrentMapItem(direction: UIPageViewController.NavigationDirection? = nil) {
        if showAdvice {
            var mapItemsWithAdvices: [DKMapItem] = []
            if let trip = viewModel.trip {
                for mapItem in self.viewModel.configurableMapItems {
                    if mapItem.getAdvice(trip: trip) != nil {
                        mapItemsWithAdvices.append(mapItem)
                    }
                }
                if mapItemsWithAdvices.count > 0 {
                    self.viewModel.displayMapItem = mapItemsWithAdvices.first
                }
            }
        }
        var index = 0
        if let mapItem = self.viewModel.displayMapItem {
            mapItemButtons.forEach { $0.isSelected = false }
            let indexItem = self.viewModel.configurableMapItems.firstIndex(of: mapItem)
            mapItemButtons[indexItem ?? 0].isSelected = true
            
            index = self.viewModel.configurableMapItems.firstIndex(of: mapItem) ?? 0
        }
        
        self.setupTipButton()
        self.pageViewController.setViewControllers([self.swipableViewControllers[index]], direction: direction ?? .forward, animated: true, completion: nil)
        self.mapViewController.traceRoute(mapItem: self.viewModel.displayMapItem)
    }
    
    func setupHeadeContainer(){
        let header = HeaderDayView.viewFromNib
        var rightText = ""
        if let dkHeader = DriveKitDriverDataUI.shared.customHeaders {
            if let text = dkHeader.customTripDetailHeader(trip: self.viewModel.trip!) {
                rightText = text
            } else {
                rightText = dkHeader.tripDetailHeader().text(trips: [self.viewModel.trip!])
            }
        } else {
            rightText = DriveKitDriverDataUI.shared.headerDay.text(trips: [self.viewModel.trip!])
        }
        header.setupAsHeader(leftText: self.viewModel.trip!.tripEndDate.format(pattern: .weekLetter),
                             rightText: rightText,
                             isRounded: false)
        header.frame = CGRect(x: 0, y: 0, width: headerContainer.frame.width, height: headerContainer.frame.height)
        headerContainer.addSubview(header)
    }
    
    func configureMapItems(){
        let mapItems = self.viewModel.configurableMapItems
        for item in mapItems {
            let itemViewController = item.viewController(trip: self.viewModel.trip!, parentViewController: self, tripDetailViewModel: self.viewModel)
            swipableViewControllers.append(itemViewController)
        }
    }
    
    func setupMapView() {
        self.mapViewController = MapViewController(viewModel: viewModel)
        mapViewController.view.frame = CGRect(x: 0, y: 0, width: self.mapContainer.frame.width, height: self.mapContainer.frame.height)
        mapContainer.addSubview(mapViewController.view)
        mapViewController.didMove(toParent: self)
    }
    
    func setupActionView(){
        self.actionView.backgroundColor = UIColor(red: 255, green: 255, blue: 255).withAlphaComponent(0.75)
        var index: Int = 0
        for item in self.viewModel.configurableMapItems {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.setImage(item.normalImage(), for: .normal)
            button.setImage(item.selectedImage(), for: .selected)
            button.tintColor = DKUIColors.primaryColor.color
            button.tag = index
            button.addTarget(self, action: #selector(selectMapItem), for: .touchUpInside)
            self.mapItemButtons.append(button)
            self.mapItemsView.addArrangedSubview(button)
            index += 1
        }
        if self.viewModel.configurableMapItems.count > 1 {
            self.mapItemViewConstraint.constant = CGFloat(self.viewModel.configurableMapItems.count * 42)
        } else {
            self.mapItemViewConstraint.constant = CGFloat(30)
        }
        self.setupCenterButton()
    }
    
    @objc func selectMapItem(sender: UIButton) {
        if !(self.viewModel.trip?.unscored ?? true) {
            var direction = UIPageViewController.NavigationDirection.forward
            if let currentIndex = mapItemButtons.firstIndex(of: sender), let mapItem = self.viewModel.displayMapItem,
                let previousIndex = self.viewModel.configurableMapItems.firstIndex(of: mapItem) {
                if previousIndex > currentIndex {
                    direction = .reverse
                } else if previousIndex < currentIndex {
                    direction = .forward
                }
            }
            if sender.tag < self.viewModel.configurableMapItems.count {
                self.viewModel.displayMapItem = self.viewModel.configurableMapItems[sender.tag]
                self.updateViewToCurrentMapItem(direction: direction)
            }
        }
    }
    
    private func setupShortTrip(){
        if let mapItem = self.viewModel.configurableMapItems.first(where: { $0.overrideShortTrip()}) {
            swipableViewControllers.append(mapItem.viewController(trip: self.viewModel.trip!, parentViewController: self, tripDetailViewModel: self.viewModel))
        } else{
            let shortTripViewModel = ShortTripPageViewModel(trip: self.viewModel.trip!)
            let shortTripVC = ShortTripPageVC(viewModel: shortTripViewModel)
            swipableViewControllers.append(shortTripVC)
        }
    }
    
    func setupPageContainer() {
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.setViewControllers([self.swipableViewControllers[0]], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.pageContainer.frame.width, height: self.pageContainer.frame.height)
        pageContainer.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
        // avoid scroll if there is only one item
        if self.viewModel.configurableMapItems.count <= 1 {
            self.pageViewController.dataSource = nil
        }
    }
    
    func setupCenterButton() {
        cameraButton.tintColor = DKUIColors.primaryColor.color
        cameraButton.setImage(UIImage(named: "dk_center_map", in: Bundle.driverDataUIBundle, compatibleWith: nil), for: .normal)
        cameraButton.addTarget(self, action: #selector(tapOnCamera(_:)), for: .touchUpInside)
    }
    
    func setupTipButton(){
        if let trip = viewModel.trip, let advice = viewModel.displayMapItem?.getAdvice(trip: trip) {
            tipButton.layer.borderColor = UIColor.black.cgColor
            tipButton.layer.cornerRadius = tipButton.bounds.size.width / 2
            tipButton.layer.masksToBounds = true
            tipButton.backgroundColor = DKUIColors.secondaryColor.color
            let image = UIImage(named: advice.getTripInfo()?.imageID() ?? "", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(32, opaque: false).withRenderingMode(.alwaysTemplate)
            tipButton.setImage(image, for: .normal)
            tipButton.tintColor = .white
            tipButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            tipButton.isHidden = false
            self.mapContainer.bringSubviewToFront(tipButton)
            if showAdvice {
                showAdvice = false
                self.clickedAdvices(tipButton)
            }
        }else{
            tipButton.isHidden = true
        }
    }
    
    @IBAction func clickedAdvices(_ sender: UIButton) {
        if let trip = viewModel.trip, let advice = viewModel.displayMapItem?.getAdvice(trip: trip) {
            let tripTipVC = TripTipViewController(trip: trip, advice: advice, tripDetailVC: self)
            let navigationTripTip = UINavigationController(rootViewController: tripTipVC)
            
            navigationTripTip.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
            navigationTripTip.navigationBar.isTranslucent = self.navigationController?.navigationBar.isTranslucent ?? false
            navigationTripTip.navigationBar.titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
            navigationTripTip.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
            self.present(navigationTripTip, animated: true, completion: nil)
        }
    }
    
    @objc func tapOnCamera(_ sender: Any) {
        self.viewModel.setSelectedEvent(position: nil)
        self.mapViewController.fitPath()
    }
}

extension TripDetailVC: TripDetailDelegate {
    
    func noRoute() {
        DispatchQueue.main.async {
            self.showNoRouteAlert()
            self.configureMapItems()
            self.setupActionView()
            self.setupHeadeContainer()
            self.setupPageContainer()
            self.updateViewToCurrentMapItem()
            self.setupTipButton()
            self.hideLoader()
        }
    }
    
    func noData() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "dk_driverdata_trip_detail_data_error".dkDriverDataLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func unScoredTrip(noRoute: Bool) {
        DispatchQueue.main.async {
            if (noRoute){
                self.showNoRouteAlert()
            }
            self.setupHeadeContainer()
            self.setupShortTrip()
            self.setupActionView()
            self.setupPageContainer()
            self.pageViewController.dataSource = nil
            self.updateViewToCurrentMapItem()
            self.hideLoader()
        }
    }
    
    func onDataAvailable(tripSyncStatus: TripSyncStatus, routeSync: Bool) {
        DispatchQueue.main.async {
            self.configureMapItems()
            self.setupActionView()
            self.setupHeadeContainer()
            self.setupPageContainer()
            self.updateViewToCurrentMapItem()
            self.hideLoader()
        }
    }
    
    func onEventSelected(event: TripEvent, position: Int){
        mapViewController.zoomToEvent(event: event)
        if let pos = viewModel.configurableMapItems.firstIndex(of: MapItem.interactiveMap) {
            (self.swipableViewControllers[pos] as! HistoryPageVC).setToPosition(position: position)
        }
    }
    
    private func showNoRouteAlert(){
        let alert = UIAlertController(title: nil, message: "dk_driverdata_trip_detail_get_road_failed".dkDriverDataLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension TripDetailVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewControllerIndex = swipableViewControllers.firstIndex(of: pendingViewControllers[0]) else {
            return
        }
        let mapItem = self.viewModel.configurableMapItems[viewControllerIndex]
        self.viewModel.displayMapItem = mapItem
        mapItemButtons.forEach { $0.isSelected = false }
        mapItemButtons[viewControllerIndex].isSelected = true
        mapViewController.traceRoute(mapItem: mapItem)
        self.setupTipButton()
    }
}

extension TripDetailVC :  UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = swipableViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        
        guard previousIndex >= 0 else {
            return swipableViewControllers.last
        }
        
        guard swipableViewControllers.count > previousIndex else {
            return nil
        }
        return swipableViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = swipableViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = swipableViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return swipableViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return swipableViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

