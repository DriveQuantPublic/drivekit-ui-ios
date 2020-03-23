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
    let viewModel : VehicleDetailViewModel
    
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
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let backImage = DKImages.back.image
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        backButton.tintColor = DKUIColors.fontColorOnPrimaryColor.color
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let checkButton = UIButton(type: .custom)
        let image = UIImage(named: "dk_check", in: Bundle.vehicleUIBundle, compatibleWith: nil)
        checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let img = image?.resizeImage(30, opaque: false).withRenderingMode(.alwaysTemplate)
        checkButton.setImage(img, for: .normal)
        checkButton.tintColor = .white
        checkButton.addTarget(self, action:#selector(updateVehicle), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkButton)
    }
    
    @objc func onBack(sender: UIBarButtonItem) {
        if viewModel.updatedFields.count > 0 {
            let alert = UIAlertController(title: nil,
                                          message: "vehicle_detail_back_edit_alert".dkVehicleLocalized(), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
                if self.viewModel.hasError {
                    self.showAlertMessage(title: nil, message: "dk_fields_not_valid".dkVehicleLocalized(), back: false, cancel: false)
                } else {
                    self.showLoader()
                    self.viewModel.updateFields(completion: { status in
                        DispatchQueue.main.async {
                            if status {
                                self.hideLoader()
                                let alert = UIAlertController(title: nil,
                                                              message: "dk_change_success".dkVehicleLocalized(),
                                                              preferredStyle: .alert)
                                let successAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(successAction)
                                self.present(alert, animated: true)
                            } else {
                                self.hideLoader()
                                self.showAlertMessage(title: nil, message: "dk_vehicle_error_message".dkVehicleLocalized(), back: false, cancel: false)
                            }
                        }
                    })
                }
            })
            let noAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .default, handler: { _ in
                
                self.viewModel.updatedName = ""
                self.viewModel.updatedFields = []
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func updateVehicle(sender: UIBarButtonItem) {
        if viewModel.hasError {
            self.showAlertMessage(title: nil, message: "dk_fields_not_valid".dkVehicleLocalized(), back: false, cancel: false)
        } else if viewModel.updatedFields.count > 0 {
            self.showLoader()
            self.viewModel.updateFields(completion: { status in
                DispatchQueue.main.async {
                    if status {
                        self.hideLoader()
                        let alert = UIAlertController(title: nil,
                                                      message: "dk_change_success".dkVehicleLocalized(),
                                                      preferredStyle: .alert)
                        let successAction = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default, handler: { _ in
                            self.viewModel.updatedName = ""
                            self.viewModel.updatedFields = []
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(successAction)
                        self.present(alert, animated: true)
                    } else {
                        self.hideLoader()
                        self.showAlertMessage(title: nil, message: "dk_vehicle_error_message".dkVehicleLocalized(), back: false, cancel: false)
                    }
                }
            })
        }
    }
}

extension VehicleDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.fields.count + 1
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
            let groupField = self.viewModel.fields[indexPath.section - 1]
            cell.viewModel = VehicleGroupFieldViewModel(groupField: groupField, vehicleCore: self, vehicle: viewModel.vehicle)
            cell.viewModel?.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        } else {
            let groupFields = self.viewModel.fields[indexPath.section - 1]
            var fieldsNb = 0
            let fields = groupFields.getFields(vehicle: self.viewModel.vehicle)
            for field in fields {
                if field.getValue(vehicle: self.viewModel.vehicle) != nil {
                    fieldsNb += 1
                }
            }
            return CGFloat(fieldsNb * 85)
        }
    }
}

extension VehicleDetailVC: VehicleDetailHeaderDelegate {
    func didSelectAddImage(cell: VehicleDetailHeader) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = DKImagePickerManager()
            imagePicker.selectedImageTag = viewModel.vehicleImage
            imagePicker.pickImage(self){ image in
                self.tableView.reloadData()
            }
        }
    }
}

extension VehicleDetailVC: VehicleDetailDelegate {
    func didUpdateVehicle() {
        self.viewModel.updatedFields = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateField(field: VehicleField, value: String) {
        if let errorIndex = self.viewModel.errorFields.firstIndex(where: {item in
            item.title == field.title
        }) {
            self.viewModel.errorFields.remove(at: errorIndex)
        }
        
        if let nameField = field as? GeneralField, nameField == .name {
            self.viewModel.updatedName = value
        }
        
        self.viewModel.updatedFields.append(field)
    }
    
    func didFailUpdateField(field: VehicleField) {
        self.viewModel.errorFields.append(field)
    }
}
