//
//  TripDetailVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 14/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData

class TripDetailVC: UIViewController {
    
    @IBOutlet var mapContainer: UIView!
    @IBOutlet var pageContainer: UIView!
    @IBOutlet var actionView: UIView!
    @IBOutlet var mapItemsView: UIStackView!
    @IBOutlet var mapItemViewConstraint: NSLayoutConstraint!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var headerContainer: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet var tipButton: UIButton!
    
    var pageViewController: UIPageViewController!
    var viewModel: TripDetailViewModel
    var swipableViewControllers: [UIViewController] = []
    var mapViewController: MapViewController!
    var mapItemButtons: [UIButton] = []
    
    let config: TripListViewConfig
    let detailConfig : TripDetailViewConfig
  
    private var showAdvice : Bool

    
    init(itinId: String, tripListViewConfig: TripListViewConfig, tripDetailViewConfig: TripDetailViewConfig, showAdvice: Bool) {
        self.viewModel = TripDetailViewModel(itinId: itinId, mapItems: tripDetailViewConfig.mapItems)
        self.config = tripListViewConfig
        self.detailConfig = tripDetailViewConfig
        self.showAdvice = showAdvice
        super.init(nibName: String(describing: TripDetailVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = detailConfig.viewTitleText
        showLoader()
        setupMapView()
        self.configureDeleteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.delegate = self
        self.configureDeleteButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.delegate = nil
    }
    
    private func configureDeleteButton(){
        if detailConfig.enableDeleteTrip {
            let image = UIImage(named: "dk_delete_trip", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
            let deleteButton = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(deleteTrip))
            deleteButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc private func deleteTrip(){
        let alert = UIAlertController(title: "", message: detailConfig.deleteText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.cancelText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: config.okText, style: .default, handler: { action in
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
        let alert = UIAlertController(title: "", message: detailConfig.failedToDeleteTrip, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessDelete() {
        let alert = UIAlertController(title: "", message: detailConfig.tripDeleted, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.delegate = nil
    }
    
    private func configureDeleteButton(){
        if detailConfig.enableDeleteTrip {
            let image = UIImage(named: "dk_delete_trip", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.resizeImage(25, opaque: false).withRenderingMode(.alwaysTemplate)
            let deleteButton = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(deleteTrip))
            deleteButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc private func deleteTrip(){
        let alert = UIAlertController(title: "", message: detailConfig.deleteText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.cancelText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: config.okText, style: .default, handler: { action in
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
        let alert = UIAlertController(title: "", message: detailConfig.failedToDeleteTrip, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessDelete() {
        let alert = UIAlertController(title: "", message: detailConfig.tripDeleted, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showLoader(){
        self.loaderView.isHidden = false
        self.loaderView.backgroundColor = UIColor(red: 97, green: 97, blue: 97).withAlphaComponent(0.5)
        self.loader.color = config.secondaryColor
        self.loader.startAnimating()
    }
    
    private func hideLoader(){
        self.loader.stopAnimating()
        self.loader.hidesWhenStopped = true
        self.loaderView.isHidden = true
    }
}

extension TripDetailVC {
    
    func updateViewToCurrentMapItem(direction: UIPageViewController.NavigationDirection? = nil) {
        if showAdvice {
            if let trip = viewModel.trip {
                for mapItem in self.viewModel.configurableMapItems {
                    if mapItem.getAdvice(trip: trip) != nil {
                        self.viewModel.displayMapItem = mapItem
                    }
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
       
        self.pageViewController.setViewControllers([self.swipableViewControllers[index]], direction: direction ?? .forward, animated: true, completion: nil)
        self.mapViewController.traceRoute(mapItem: self.viewModel.displayMapItem)
    }
    
    func setupHeadeContainer(){
        let header = HeaderDayView.viewFromNib
        let headerDay: HeaderDay = .distanceDuration
        header.setupAsHeader(backGroundColor: config.primaryColor,
                             fontColor: .white, fontSize: 14,
                             leftText: self.viewModel.trip!.tripEndDate.dateToDay(),
                             rightText: headerDay.text(trips: [self.viewModel.trip!]),
                             isRounded: false)
        header.frame = CGRect(x: 0, y: 0, width: headerContainer.frame.width, height: headerContainer.frame.height)
        headerContainer.addSubview(header)
    }
    
    func configureMapItems(){
        let mapItems = self.viewModel.configurableMapItems
        for item in mapItems {
            switch item {
            case .safety:
                self.setupSafety()
            case .ecoDriving:
                self.setupEcoDriving()
            case .distraction:
                self.setupDistraction()
            case .interactiveMap:
                self.setupHistory()
            }
        }
    }
    
    func setupMapView() {
        self.mapViewController = MapViewController(viewModel: viewModel, config: config, detailConfig: detailConfig)
        mapViewController.view.frame = CGRect(x: 0, y: 0, width: self.mapContainer.frame.width, height: self.mapContainer.frame.height)
        mapContainer.addSubview(mapViewController.view)
        mapViewController.didMove(toParent: self)
    }
    
    func setupActionView(){
        self.actionView.backgroundColor = UIColor(red: 255, green: 255, blue: 255).withAlphaComponent(0.75)
        for item in self.viewModel.configurableMapItems {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.setImage(UIImage(named: item.normalImageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.setImage(UIImage(named: item.selectedImageID(), in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .selected)
            button.tintColor = config.primaryColor
            button.tag = item.tag
            button.addTarget(self, action: #selector(selectMapItem), for: .touchUpInside)
            self.mapItemButtons.append(button)
            self.mapItemsView.addArrangedSubview(button)
        }
        self.mapItemViewConstraint.constant = CGFloat(self.viewModel.configurableMapItems.count * 42)
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
            
            switch sender.tag {
            case 0:
                self.viewModel.displayMapItem = .safety
            case 1:
                self.viewModel.displayMapItem = .ecoDriving
            case 2:
                self.viewModel.displayMapItem = .interactiveMap
            case 3:
                self.viewModel.displayMapItem = .distraction
            default:
                self.viewModel.displayMapItem = .safety
            }
            
            self.updateViewToCurrentMapItem(direction: direction)
        }
    }
    
    func setupShortTrip(){
        let shortTripViewModel = ShortTripPageViewModel(trip: self.viewModel.trip!)
        let shortTripVC = ShortTripPageVC(viewModel: shortTripViewModel, detailConfig: detailConfig)
        swipableViewControllers.append(shortTripVC)
    }
    
    func setupSafety(){
        let safetyViewModel = SafetyPageViewModel(trip: self.viewModel.trip!)
        let safetyVC = SafetyPageVC(viewModel: safetyViewModel, config: config, detailConfig: detailConfig)
        swipableViewControllers.append(safetyVC)
    }
    
    func setupEcoDriving(){
        let ecoDrivingViewModel = EcoDrivingPageViewModel(trip: self.viewModel.trip!, detailConfig: detailConfig)
        let ecoDrivingVC = EcoDrivingPageVC(viewModel: ecoDrivingViewModel, config: config, detailConfig: detailConfig)
        swipableViewControllers.append(ecoDrivingVC)
    }
    
    func setupDistraction(){
        let distractionViewModel = DistractionPageViewModel(trip: self.viewModel.trip!)
        let distractionVC = DistractionPageVC(viewModel: distractionViewModel, config: config, detailConfig: detailConfig)
        swipableViewControllers.append(distractionVC)
    }
    
    func setupHistory(){
        let historyViewModel = HistoryPageViewModel(events: self.viewModel.events, tripDetailViewModel: viewModel)
        let historyVC = HistoryPageVC(viewModel: historyViewModel, detailConfig: detailConfig, config: config)
        swipableViewControllers.append(historyVC)
    }
    
    func setupPageContainer() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.setViewControllers([self.swipableViewControllers[0]], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.pageContainer.frame.width, height: self.pageContainer.frame.height)
        pageContainer.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
    
    func setupCenterButton() {
        cameraButton.tintColor = config.primaryColor
        cameraButton.setImage(UIImage(named: "dk_center_map", in: Bundle.driverDataUIBundle, compatibleWith: nil), for: .normal)
        cameraButton.addTarget(self, action: #selector(tapOnCamera(_:)), for: .touchUpInside)
    }
    
    func setupTipButton(){
        if let trip = viewModel.trip, let advice = viewModel.displayMapItem?.getAdvice(trip: trip) {
            tipButton.layer.borderColor = UIColor.black.cgColor
            tipButton.layer.cornerRadius = tipButton.bounds.size.width / 2
            tipButton.layer.masksToBounds = true
            tipButton.backgroundColor = config.secondaryColor
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
    
    @IBAction func clickedAdvices(_ sender: Any) {
        if let trip = viewModel.trip, let advice = viewModel.displayMapItem?.getAdvice(trip: trip) {
            let tripTipVC = TripTipViewController(config: config, advice: advice)
            self.present(tripTipVC, animated: true, completion: nil)
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
            let alert = UIAlertController(title: nil, message: self.detailConfig.errorEventText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.config.okText, style: .cancel, handler: { action in
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
            self.setupTipButton()
            self.hideLoader()
        }
    }
    
    func onEventSelected(event: TripEvent, position: Int){
        mapViewController.zoomToEvent(event: event)
        if let pos = viewModel.configurableMapItems.firstIndex(of: .interactiveMap) {
            (self.swipableViewControllers[pos] as! HistoryPageVC).setToPosition(position: position)
        }
    }
    
    private func showNoRouteAlert(){
        let alert = UIAlertController(title: nil, message: self.detailConfig.errorRouteText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.config.okText, style: .cancel, handler: nil))
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

