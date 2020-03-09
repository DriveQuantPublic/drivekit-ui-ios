//
//  VehiclePickerCollectionViewVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

private struct Constants {
    static let insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    static let minimumInteritemSpacing: CGFloat = 8
    static let minimumLineSpacing: CGFloat = 8
}

class VehiclePickerCollectionViewVC: VehiclePickerStepView {
    @IBOutlet weak var collectionView: UICollectionView!

    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerCollectionViewVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "VehiclePickerImageCollectionViewCell", bundle: .vehicleUIBundle), forCellWithReuseIdentifier: "VehiclePickerImageCollectionViewCell")
        collectionView.register(UINib(nibName: "VehiclePickerLabelCollectionViewCell", bundle: .vehicleUIBundle), forCellWithReuseIdentifier: "VehiclePickerLabelCollectionViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
}
extension VehiclePickerCollectionViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCollectionViewItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let value = viewModel.getCollectionViewItems()[indexPath.row]
        if let image = value.image() {
            let cell: VehiclePickerImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehiclePickerImageCollectionViewCell", for: indexPath) as! VehiclePickerImageCollectionViewCell
                   cell.configure(image: image, text: value.title(), showLabel: viewModel.showStepLabel())
                   return cell
        }else{
            let cell : VehiclePickerLabelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehiclePickerLabelCollectionViewCell", for: indexPath) as! VehiclePickerLabelCollectionViewCell
            cell.configure(text: value.title())
            return cell
        }
    }
}

extension VehiclePickerCollectionViewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.insets.left - Constants.insets.right - Constants.minimumInteritemSpacing) / 2
        let height = width
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showLoader()
        viewModel.onCollectionViewItemSelected(pos: indexPath.row, completion: {status in
            self.hideLoader()
            switch status {
            case .noError:
                self.viewModel.coordinator.showStep(viewController: self.viewModel.getViewController())
            case .noData:
                self.showAlertMessage(title: nil, message: "No data retrieved for selection", back: false, cancel: false)
            case .failedToRetreiveData:
                self.showAlertMessage(title: nil, message: "Failed to retreive data", back: false, cancel: false)
            }
        })
    }
}
