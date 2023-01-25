// swiftlint:disable all
//
//  WorkingHoursViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class WorkingHoursViewController: DKUIViewController {
    @IBOutlet private weak var activationTitleLabel: UILabel!
    @IBOutlet private weak var activationDescriptionLabel: UILabel!
    @IBOutlet private weak var activationSwitch: UISwitch!
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: WorkingHoursViewModel

    public init() {
        self.viewModel = WorkingHoursViewModel()
        super.init(nibName: String(describing: WorkingHoursViewController.self), bundle: Bundle.tripAnalysisUIBundle)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        showLoader()
        self.viewModel.synchronizeWorkingHours()
    }

    private func setup() {
        self.title = "dk_working_hours_title".dkTripAnalysisLocalized()

        self.view.backgroundColor = .white
        self.activationSwitch.isOn = self.viewModel.isActivated
        self.activationTitleLabel.text = "dk_working_hours_enable_title".dkTripAnalysisLocalized()
        self.activationDescriptionLabel.text = "dk_working_hours_enable_desc".dkTripAnalysisLocalized()

        self.activationSwitch.onTintColor = DKUIColors.secondaryColor.color
        self.activationTitleLabel.font = DKStyles.normalText.style.applyTo(font: .primary)
        self.activationTitleLabel.textColor = DKUIColors.primaryColor.color
        self.activationDescriptionLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.activationDescriptionLabel.textColor = DKUIColors.complementaryFontColor.color

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "WorkingHoursSlotCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "WorkingHoursSlotCell")
        self.tableView.register(UINib(nibName: "WorkingHoursSeparatorCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "WorkingHoursSeparatorCell")
        self.tableView.register(UINib(nibName: "WorkingHoursDayCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "WorkingHoursDayCell")

        self.configureBackButton(selector: #selector(back))
    }

    @IBAction private func activationSwitchDidUpdate() {
        self.viewModel.activate(self.activationSwitch.isOn)
        self.tableView.reloadData()
    }

    @objc func back() {
        if self.viewModel.hasModifications {
            let alert = UIAlertController(title: nil, message: "dk_working_hours_back_save_alert".dkTripAnalysisLocalized(), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: DKCommonLocalizable.confirm.text(), style: .default) { _ in
                self.updateWorkingHours {
                    if !self.viewModel.hasModifications {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            let noAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel) { [weak self]  _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func updateWorkingHours(completion: @escaping () -> Void) {
        self.showLoader()
        self.navigationItem.rightBarButtonItem = nil
        self.viewModel.updateWorkingHours { [weak self] success in
            if let self = self {
                DispatchQueue.dispatchOnMainThread {
                    self.hideLoader()
                    self.workingHoursDidModify()
                    if success {
                        completion()
                    } else {
                        self.showAlertMessage(title: nil, message: "dk_working_hours_update_failed".dkTripAnalysisLocalized(), back: false, cancel: false)
                    }
                }
            }
        }
    }

    @objc private func saveWorkingHours() {
        updateWorkingHours {
            self.showAlertMessage(title: nil, message: "dk_working_hours_update_succeed".dkTripAnalysisLocalized(), back: false, cancel: false)
        }
    }
}

extension WorkingHoursViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sections[indexPath.row] {
            case .slot:
                return 70
            case .separator:
                return 1
            case .day:
                return 80
        }
    }
}

extension WorkingHoursViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sections[indexPath.row] {
            case let .slot(slotType):
                let slotCell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursSlotCell", for: indexPath) as! WorkingHoursSlotCell
                let viewModel = self.viewModel.getSlotCellViewModel(type: slotType)
                slotCell.configure(viewModel: viewModel, parentViewController: self)
                return slotCell
            case .separator:
                return tableView.dequeueReusableCell(withIdentifier: "WorkingHoursSeparatorCell", for: indexPath)
            case let .day(day):
                let dayCell = tableView.dequeueReusableCell(withIdentifier: "WorkingHoursDayCell", for: indexPath) as! WorkingHoursDayCell
                let viewModel = self.viewModel.getDayCellViewModel(day: day)
                dayCell.configure(viewModel: viewModel)
                return dayCell
        }
    }
}

extension WorkingHoursViewController: WorkingHoursViewModelDelegate {
    func workingHoursViewModelDidUpdate() {
        hideLoader()
        self.activationSwitch.isOn = self.viewModel.isActivated
        self.tableView.reloadData()
    }

    func workingHoursDidModify() {
        if self.viewModel.hasModifications {
            if self.navigationItem.rightBarButtonItem == nil {
                let checkButton = UIButton(type: .custom)
                let image = DKImages.check.image?.resizeImage(30, opaque: false).withRenderingMode(.alwaysTemplate)
                checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                checkButton.setImage(image, for: .normal)
                checkButton.tintColor = DKUIColors.navBarElementColor.color
                checkButton.addTarget(self, action: #selector(saveWorkingHours), for: .touchUpInside)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkButton)
            }
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}
