//
//  ActivationHoursViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 16/12/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ActivationHoursViewController: DKUIViewController {
    @IBOutlet private weak var activationTitleLabel: UILabel!
    @IBOutlet private weak var activationDescriptionLabel: UILabel!
    @IBOutlet private weak var activationSwitch: UISwitch!
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: ActivationHoursViewModel

    public init() {
        self.viewModel = ActivationHoursViewModel()
        super.init(nibName: String(describing: ActivationHoursViewController.self), bundle: Bundle.tripAnalysisUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
        self.tableView.register(UINib(nibName: "ActivationHoursSlotCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursSlotCell")
        self.tableView.register(UINib(nibName: "ActivationHoursSeparatorCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursSeparatorCell")
        self.tableView.register(UINib(nibName: "ActivationHoursDayCell", bundle: Bundle.tripAnalysisUIBundle), forCellReuseIdentifier: "ActivationHoursDayCell")
    }

    @IBAction private func activationSwitchDidUpdate() {
        self.viewModel.activate(self.activationSwitch.isOn)
        self.tableView.reloadData()
    }
}

extension ActivationHoursViewController: UITableViewDelegate {
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

extension ActivationHoursViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sections[indexPath.row] {
            case let .slot(slotType):
                let slotCell = tableView.dequeueReusableCell(withIdentifier: "ActivationHoursSlotCell", for: indexPath) as! ActivationHoursSlotCell
                let viewModel = self.viewModel.getSlotCellViewModel(type: slotType)
                slotCell.configure(viewModel: viewModel, parentViewController: self)
                return slotCell
            case .separator:
                return tableView.dequeueReusableCell(withIdentifier: "ActivationHoursSeparatorCell", for: indexPath)
            case let .day(day):
                let dayCell = tableView.dequeueReusableCell(withIdentifier: "ActivationHoursDayCell", for: indexPath) as! ActivationHoursDayCell
                let viewModel = self.viewModel.getDayCellViewModel(day: day)
                dayCell.configure(viewModel: viewModel)
                return dayCell
        }
    }
}

extension ActivationHoursViewController: DKActivationHoursConfigDelegate {
    func onActivationHoursAvaiblale() {
        
    }
    
    func onActivationHoursUpdated() {
        
    }
    
    func didReceiveErrorFromService() {
        
    }
}
