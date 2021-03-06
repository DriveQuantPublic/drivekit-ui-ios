//
//  ChallengeTripsVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 04/06/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeTripsVC: DKUIViewController {
    @IBOutlet private weak var titleAttributedLabel: UILabel?
    @IBOutlet private weak var dateAttributedLabel: UILabel?
    @IBOutlet private weak var tripsStackView: UIStackView?

    private let viewModel: ChallengeDetailViewModel
    private let tripsVC: TripsListTableVC<ChallengeTrip>

    public init(viewModel: ChallengeDetailViewModel) {
        self.viewModel = viewModel
        self.tripsVC = TripsListTableVC<ChallengeTrip>(viewModel: viewModel.getTripListViewModel())
        super.init(nibName: String(describing: ChallengeTripsVC.self), bundle: Bundle.challengeUIBundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(tripsVC)
        let defaultBackgroundColor = DKDefaultColors.driveKitBackgroundColor
        self.view.backgroundColor = defaultBackgroundColor
        if let tripsTableView = tripsVC.tableView {
            tripsTableView.backgroundColor = defaultBackgroundColor
            self.tripsStackView?.addArrangedSubview(tripsTableView)
        }
        self.titleAttributedLabel?.attributedText = viewModel.getTitleAttributedString()
        self.dateAttributedLabel?.attributedText = viewModel.getDateAttributedString()
    }

    func refreshUI() {
        self.titleAttributedLabel?.attributedText = viewModel.getTitleAttributedString()
        self.dateAttributedLabel?.attributedText = viewModel.getDateAttributedString()
        tripsVC.tableView?.reloadData()
    }

    func didSelectTrip(itinId: String, showAdvice: Bool) {
        viewModel.delegate?.didSelectTrip(tripId: itinId, showAdvice: showAdvice)
    }
}
