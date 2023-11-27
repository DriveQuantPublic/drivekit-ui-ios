// swiftlint:disable no_magic_numbers
//
//  VehiclePickerCollectionViewVC.swift
//  drivekit-test-app
//
//  Created by Meryl Barantal on 20/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

private enum Constants {
    static let insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    static let minimumInteritemSpacing: CGFloat = 8
    static let minimumLineSpacing: CGFloat = 8
}

class VehiclePickerCollectionViewVC: VehiclePickerStepView {
    @IBOutlet weak var collectionView: UICollectionView!

    init(viewModel: VehiclePickerViewModel) {
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
        collectionView.register(
            UINib(nibName: "VehiclePickerImageCollectionViewCell", bundle: .vehicleUIBundle),
            forCellWithReuseIdentifier: "VehiclePickerImageCollectionViewCell"
        )
        collectionView.register(
            UINib(nibName: "VehiclePickerLabelCollectionViewCell", bundle: .vehicleUIBundle),
            forCellWithReuseIdentifier: "VehiclePickerLabelCollectionViewCell"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.viewModel.vehicleDataDelegate = self
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
            let cell: VehiclePickerImageCollectionViewCell = collectionView.dequeue(
                withReuseIdentifier: "VehiclePickerImageCollectionViewCell",
                for: indexPath
            )
            cell.configure(image: image, text: value.title(), showLabel: viewModel.showStepLabel())
            return cell
        } else {
            let cell: VehiclePickerLabelCollectionViewCell = collectionView.dequeue(
                withReuseIdentifier: "VehiclePickerLabelCollectionViewCell",
                for: indexPath
            )
            cell.configure(text: value.title())
            return cell
        }
    }
}

extension VehiclePickerCollectionViewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.insets.left - Constants.insets.right - Constants.minimumInteritemSpacing) / 2
        let height = self.viewModel.showStepLabel() ? width + 16 : width
        return CGSize(width: width, height: height)
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
        self.viewModel.onCollectionViewItemSelected(pos: indexPath.row, completion: { status in
            if status == .noData {
                self.hideLoader()
                self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
            }
        })
    }
}

extension VehiclePickerCollectionViewVC: VehicleDataDelegate {
    func onDataRetrieved(status: StepStatus) {
        DispatchQueue.dispatchOnMainThread {
            self.hideLoader()
            switch status {
                case .noError:
                    self.viewModel.showStep()
                case .noData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
                case .failedToRetreiveData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_failed_to_retrieve_vehicle_data".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }
}
