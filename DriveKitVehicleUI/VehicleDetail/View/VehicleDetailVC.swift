//
//  VehicleDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 12/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehicleDetailVC : DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel: VehicleDetailViewModel

    public init(viewModel: VehicleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: VehicleDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.viewModel.delegate = self
        self.tableView.register(UINib(nibName: "VehicleGroupFieldsCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleGroupFieldsCell")
        self.tableView.register(UINib(nibName: "VehicleDetailHeader", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "VehicleDetailHeader")
        self.tableView.backgroundColor = DKUIColors.backgroundView.color
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func setupNavigationBar() {
        self.title = self.viewModel.vehicleDisplayName
        self.configureBackButton(selector: #selector(onDetailBack))
    }

    @objc func onDetailBack(sender: UIBarButtonItem) {
        if viewModel.mustUpdate() {
            self.showUpdateConfirmationAlert()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func showUpdateConfirmationAlert() {
        let alert = UIAlertController(title: nil, message: "dk_vehicle_detail_back_edit_alert".dkVehicleLocalized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
            self.showLoader()
            self.updateField(succesAlertAction : { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        })
        let noAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .default, handler: {  [weak self]  _ in
            self?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }

    @objc func updateVehicle(sender: UIBarButtonItem) {
        self.showLoader()
        self.updateField(succesAlertAction: { [weak self] _ in
            if !(self?.viewModel.mustUpdate() ?? true){
                self?.navigationItem.rightBarButtonItem = nil
            }
        })
    }

    private func updateField(succesAlertAction : ((UIAlertAction) -> Void)?) {
        self.viewModel.updateFields(completion: { [weak self] status in
            DispatchQueue.main.async {
                self?.hideLoader()
                if status {
                    let alert = UIAlertController(title: nil, message: "dk_change_success".dkVehicleLocalized(), preferredStyle: .alert)
                    let successAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: succesAlertAction)
                    alert.addAction(successAction)
                    self?.present(alert, animated: true)
                }else{
                    self?.tableView.reloadData()
                    self?.showAlertMessage(title: nil, message: "dk_fields_not_valid".dkVehicleLocalized(), back: false, cancel: false)
                }
            }
        })
    }
}

extension VehicleDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.groupFields.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell : VehicleDetailHeader = self.tableView.dequeueReusableCell(withIdentifier: "VehicleDetailHeader", for: indexPath) as! VehicleDetailHeader
            cell.configure(vehicleName: self.viewModel.vehicleDisplayName, vehicleImage: viewModel.vehicle.getVehicleImage())
            cell.delegate = self
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            return cell
        } else {
            let cell : VehicleGroupFieldsCell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleGroupFieldsCell", for: indexPath) as! VehicleGroupFieldsCell
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            let groupField = self.viewModel.groupFields[indexPath.section - 1]
            cell.configure(viewModel: viewModel, groupField: groupField)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else {
            let groupFields = self.viewModel.groupFields[indexPath.section - 1]
            let fields = groupFields.getFields(vehicle: self.viewModel.vehicle)
            let width = tableView.bounds.size.width - self.viewModel.textFieldTotalHorizontalPadding * 2
            return fields.map({ $0.cellHeightForWidth(width, vehicle: self.viewModel.vehicle) }).reduce(0, +) + self.viewModel.cellVerticalPadding * 2
        }
    }
}

extension VehicleDetailVC: VehicleDetailHeaderDelegate {
    func didSelectAddImage(cell: VehicleDetailHeader) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = DKImagePickerManager()
            imagePicker.selectedImageTag = viewModel.vehicle.vehicleImageTag
            imagePicker.pickImage(self){ image in
                self.tableView.reloadData()
            }
        }
    }
}

extension VehicleDetailVC: VehicleDetailDelegate {
    func needUpdate() {
        let checkButton = UIButton(type: .custom)
        let image = UIImage(named: "dk_check", in: Bundle.vehicleUIBundle, compatibleWith: nil)
        checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let img = image?.resizeImage(30, opaque: false).withRenderingMode(.alwaysTemplate)
        checkButton.setImage(img, for: .normal)
        checkButton.tintColor = DKUIColors.fontColorOnPrimaryColor.color
        checkButton.addTarget(self, action:#selector(updateVehicle), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkButton)
    }
}
