//
//  StreakVCViewController.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 07/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

public class StreakViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel : StreakViewModel
    
    public init() {
        self.viewModel = StreakViewModel()
        super.init(nibName: String(describing: StreakViewController.self), bundle: Bundle.driverAchievementUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.getStreakData()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // self.collectionView.dataSource = self
        let nib = UINib(nibName: "StreakTableViewCell", bundle: Bundle.driverAchievementUIBundle)
        tableView.register(nib, forCellReuseIdentifier: "StreakTableViewCell")
        //self.collectionView.collectionViewLayout = CardViewFlowLayout()
        /*if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }*/
       // self.collectionView.register(StreakCollectionViewCell.nib, forCellWithReuseIdentifier: "StreakCollectionViewCell")
    }
}

extension StreakViewController : StreakVMDelegate {
    func streaksUpdated() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
}

extension StreakViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.streakData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : StreakTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StreakTableViewCell", for: indexPath) as? StreakTableViewCell {
            cell.configure(streakData: self.viewModel.streakData[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension StreakViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension StreakViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.streakData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell : StreakCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreakCollectionViewCell", for: indexPath) as? StreakCollectionViewCell {
            cell.configure(streakData: self.viewModel.streakData[indexPath.section])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension Bundle {
    static let driverAchievementUIBundle = Bundle(identifier: "com.drivequant.drivekit-driver-achievement-ui")
}
