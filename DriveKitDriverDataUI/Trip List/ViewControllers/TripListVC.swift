//
//  TripListVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 03/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

public class TripListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loaderView: UIView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var noTripsView: UIView!
    @IBOutlet var noTripsImage: UIImageView!
    @IBOutlet var noTripsLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    let viewModel: TripListViewModel
    let config: TripListViewConfig
    let detailConfig: TripDetailViewConfig
    
    public init(config: TripListViewConfig, detailConfig: TripDetailViewConfig) {
        self.config = config
        self.detailConfig = detailConfig
        self.viewModel = TripListViewModel(dayTripDescendingOrder: config.dayTripDescendingOrder) 
        super.init(nibName: String(describing: TripListVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = config.viewTitleText
        self.tableView.register(TripTableViewCell.nib, forCellReuseIdentifier: "TripTableViewCell")
        if #available(iOS 11, *) {
          tableView.separatorInset = .zero
        }
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTripList(_ :)), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.showLoader()
        self.viewModel.delegate = self
    }
    
    func showLoader(){
        self.loaderView.isHidden = false
        self.loaderView.backgroundColor = UIColor(red: 97, green: 97, blue: 97).withAlphaComponent(0.5)
        self.loader.color = config.secondaryColor
        self.loader.startAnimating()
    }
    
    func hideLoader(){
        self.loader.stopAnimating()
        self.loader.hidesWhenStopped = true
        self.loaderView.isHidden = true
    }

    func updateUI() {
        if self.viewModel.status == .failedToSyncTripsCacheOnly {
            let alert = UIAlertController(title: nil, message: config.failedToSyncTrip, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: config.okText, style: .cancel, handler: { action in
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.viewModel.trips.count > 0 {
            self.noTripsView.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        } else {
            self.noTripsView.isHidden = false
            self.tableView.isHidden = true
            self.noTripsImage.image = UIImage(named: config.noTripsRecordedImage, in: Bundle.driverDataUIBundle, compatibleWith: nil)
            self.noTripsLabel.text = config.noTripsRecordedText
        }
    }

    @objc func refreshTripList(_ sender: Any) {
        self.viewModel.fetchTrips()
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
