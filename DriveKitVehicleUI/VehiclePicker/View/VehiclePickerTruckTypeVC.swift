// swiftlint:disable no_magic_numbers
//
//  VehiclePickerTruckTypeVC.swift
//  DriveKitVehicleUI
//
//  Created by David Bauduin on 03/06/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

private enum Constants {
    static let insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    static let minimumInteritemSpacing: CGFloat = 8
    static let minimumLineSpacing: CGFloat = 8
}

class VehiclePickerTruckTypeVC: VehiclePickerStepView {
    @IBOutlet private weak var collectionView: UICollectionView!

    init(viewModel: VehiclePickerStepViewModel) {
        super.init(nibName: String(describing: VehiclePickerTruckTypeVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib(nibName: "VehiclePickerImageCollectionViewCell", bundle: .vehicleUIBundle),
            forCellWithReuseIdentifier: "VehiclePickerImageCollectionViewCell"
        )
        self.collectionView.register(
            UINib(nibName: "VehiclePickerLabelCollectionViewCell", bundle: .vehicleUIBundle),
            forCellWithReuseIdentifier: "VehiclePickerLabelCollectionViewCell"
        )
        self.collectionView.register(
            UINib(nibName: "VehiclePickerTruckTypeHeader", bundle: .vehicleUIBundle),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "VehiclePickerTruckTypeHeader"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.collectionView.reloadData()
        self.viewModel.pickerViewModel.vehicleDataDelegate = self
    }
}

extension VehiclePickerTruckTypeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getCollectionViewItems().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let value = self.viewModel.getCollectionViewItems()[indexPath.row]
        if let image = value.image() {
            let cell: VehiclePickerImageCollectionViewCell = collectionView.dequeue(
                withReuseIdentifier: "VehiclePickerImageCollectionViewCell",
                for: indexPath
            )
            cell.configure(image: image, text: value.title(), showLabel: self.viewModel.showStepLabel())
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "VehiclePickerTruckTypeHeader",
            for: indexPath
        ) as? VehiclePickerTruckTypeHeader else { fatalError() }
        if let description = self.viewModel.getStepDescription() {
            headerView.titleLabel.attributedText = description.dkAttributedString().font(dkFont: .primary, style: .bigtext).color(.mainFontColor).build()
        }
        return headerView
    }
}

extension VehiclePickerTruckTypeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - Constants.insets.left - Constants.insets.right - Constants.minimumInteritemSpacing
        let height = (width * 0.4).rounded() + (self.viewModel.showStepLabel() ? 16 : 0)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showLoader()
        viewModel.onCollectionViewItemSelected(pos: indexPath.row, completion: { status in
            if status == .noData {
                self.hideLoader()
                self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
            }
        })
    }
}

extension VehiclePickerTruckTypeVC: VehicleDataDelegate {
    func onDataRetrieved(status: StepStatus) {
        DispatchQueue.dispatchOnMainThread {
            self.hideLoader()
            switch status {
                case .noError:
                    self.viewModel.pickerViewModel.showStep()
                case .noData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_no_data".dkVehicleLocalized(), back: false, cancel: false)
                case .failedToRetreiveData:
                    self.showAlertMessage(title: nil, message: "dk_vehicle_failed_to_retrieve_vehicle_data".dkVehicleLocalized(), back: false, cancel: false)
            }
        }
    }
}
