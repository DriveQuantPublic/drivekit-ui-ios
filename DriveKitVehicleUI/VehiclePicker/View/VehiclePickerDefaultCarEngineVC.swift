// swiftlint:disable no_magic_numbers
//
//  VehiclePickerDefaultCarEngineVC.swift
//  DriveKitVehicleUI
//
//  Created by Amine Gahbiche on 12/12/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class VehiclePickerDefaultCarEngineVC: VehiclePickerStepView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet private weak var topConstraint: NSLayoutConstraint!

    var selectedRow: Int = 1

    init (viewModel: VehiclePickerViewModel) {
        super.init(nibName: String(describing: VehiclePickerDefaultCarEngineVC.self), bundle: .vehicleUIBundle)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable:next prohibited_super_call
    override func loadView() {
        super.loadView()
        self.tableView.register(VehiclePickerDefaultCarEngineCell.self, forCellReuseIdentifier: VehiclePickerDefaultCarEngineCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    func setup() {
        let topMarginDistance: CGFloat = 20
        self.topConstraint.constant = topMarginDistance
        imageView.image = DKVehicleImages.vehicleIsItElectric.image
        textLabel.attributedText = "dk_vehicle_is_it_electric"
            .dkVehicleLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: .normalText)
            .color(.mainFontColor)
            .build()
        confirmButton.configure(title: DKCommonLocalizable.validate.text(), style: .full)
        self.title = "dk_motor".dkVehicleLocalized()
    }

    @IBAction func didConfirmInput(_ sender: Any) {
        self.viewModel.isElectric = (selectedRow == 0)
        self.viewModel.nextStep(.defaultCarEngine)
    }
}

extension VehiclePickerDefaultCarEngineVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == selectedRow {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
    }
}

extension VehiclePickerDefaultCarEngineVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VehiclePickerDefaultCarEngineCell = tableView.dequeue(withIdentifier: VehiclePickerDefaultCarEngineCell.reuseIdentifier)
        if indexPath.row == 0 {
            cell.textLabel?.text = DKCommonLocalizable.yes.text()
        } else if indexPath.row == 1 {
            cell.textLabel?.text = DKCommonLocalizable.no.text()
        }
        cell.updateStyle(selected: selectedRow == indexPath.row)
        return cell
    }
}
