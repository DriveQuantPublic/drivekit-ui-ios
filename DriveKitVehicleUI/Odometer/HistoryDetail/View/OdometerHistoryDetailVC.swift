// swiftlint:disable all
//
//  OdometerHistoryDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Meryl Barantal on 09/08/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitCoreModule
import DriveKitDBVehicleAccessModule

class OdometerHistoryDetailVC: DKUIViewController {
    @IBOutlet private weak var panelView: UIView!
    @IBOutlet private weak var panelTitle: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!

    @IBOutlet private weak var validateView: UIView!
    @IBOutlet private weak var cancelView: UIView!
    @IBOutlet private weak var deleteView: UIView!

    let viewModel: OdometerHistoryDetailViewModel

    init(viewModel: OdometerHistoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: OdometerHistoryDetailVC.self), bundle: Bundle.vehicleUIBundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        self.view.backgroundColor = .white
        self.deleteView.isHidden = !self.viewModel.canDelete()

        self.panelTitle.attributedText = "dk_vehicle_odometer_odometer_history_detail_title".dkVehicleLocalized().uppercased().dkAttributedString().font(dkFont: .primary, style: .normalText).color(.secondaryColor).build()
        self.validateButton.configure(text: DKCommonLocalizable.validate.text(), style: .full)
        self.cancelButton.configure(text: DKCommonLocalizable.cancel.text(), style: .empty)
        self.deleteButton.configure(text: DKCommonLocalizable.delete.text(), style: .empty)

        self.title = self.viewModel.getTitle()
        self.tableView.separatorStyle = .none
        self.tableView.sectionIndexBackgroundColor = .white
        self.tableView.register(OdometerHistoryDetailCell.nib, forCellReuseIdentifier: "OdometerHistoryDetailCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.delegate = self
        self.tableView.dataSource = self

        if #available(iOS 15, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }

        if self.viewModel.isEditable {
            self.cancelView.isHidden = false
            self.validateView.isHidden = false
        } else {
            self.cancelView.isHidden = true
            self.validateView.isHidden = true
        }
    }

    @IBAction private func validateReference(_ sender: Any) {
        self.viewModel.validateHistory(viewController: self) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction private func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction private func deleteReference(_ sender: Any) {
        self.viewModel.deleteHistory(viewController: self)
    }
}

extension OdometerHistoryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = .clear
        return headerView
    }
}

extension OdometerHistoryDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OdometerHistoryDetailCell", for: indexPath) as! OdometerHistoryDetailCell
        let viewModel = self.viewModel.getOdometerHistoryDetailCellViewModel(at: indexPath.section)
        cell.configure(viewModel: viewModel)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension OdometerHistoryDetailVC: OdometerHistoryDelegate {
    func didUpdateDistanceField(distance: Double, sender: OdometerHistoryDetailCell) {
        self.viewModel.updatedValue = distance
    }
}
