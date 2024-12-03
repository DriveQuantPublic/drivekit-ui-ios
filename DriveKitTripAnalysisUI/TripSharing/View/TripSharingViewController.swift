//
//  TripSharingViewController.swift
//  DriveKitTripAnalysisUI
//
//  Created by Amine Gahbiche on 02/12/2024.
//  Copyright © 2024 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class TripSharingViewController: DKUIViewController {
    
    @IBOutlet weak var activateShareButton: UIButton!
    @IBOutlet weak var oneDayButton: UIButton!
    @IBOutlet weak var oneWeekButton: UIButton!
    @IBOutlet weak var oneMonthButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shareLinkButton: UIButton!
    @IBOutlet weak var revokeLinkButton: UIButton!

    @IBOutlet weak var notActiveStackView: UIStackView!
    @IBOutlet weak var selectPeriodStackView: UIStackView!
    @IBOutlet weak var activeStackView: UIStackView!

    private let viewModel: TripSharingViewModel
    
    init() {
        self.viewModel = TripSharingViewModel()
        super.init(nibName: String(describing: TripSharingViewController.self), bundle: Bundle.tripAnalysisUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showLoader()
        self.viewModel.updateStatus {
            DispatchQueue.dispatchOnMainThread {
                self.hideLoader()
                self.updateView()
            }
        }
    }

    func setup() {
        self.title = "dk_location_sharing_title".dkTripAnalysisLocalized()
        self.view.backgroundColor = .white
        
        self.activateShareButton.configure(title: "dk_location_sharing_inactive_enable".dkTripAnalysisLocalized(), style: .full)
        self.oneDayButton.configure(title: "dk_location_sharing_select_day".dkTripAnalysisLocalized(), style: .full)
        self.oneWeekButton.configure(title: "dk_location_sharing_select_week".dkTripAnalysisLocalized(), style: .full)
        self.oneMonthButton.configure(title: "dk_location_sharing_select_month".dkTripAnalysisLocalized(), style: .full)
        self.cancelButton.setAttributedTitle(
            "dk_location_sharing_select_cancel"
                .dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .button)
                .color(.criticalColor)
                .build(),
            for: .normal
        )
        self.shareLinkButton.configure(title: "dk_location_sharing_active_share_link".dkTripAnalysisLocalized().uppercased(), style: .full)
        self.revokeLinkButton.setAttributedTitle(
            "dk_location_sharing_active_disable"
                .dkTripAnalysisLocalized()
                .dkAttributedString()
                .font(dkFont: .primary, style: .button)
                .color(.criticalColor)
                .build(),
            for: .normal
        )
    }

    func updateView() {
        let status = self.viewModel.status
        switch status {
            case .loading:
                self.activeStackView.isHidden = true
                self.notActiveStackView.isHidden = true
                self.selectPeriodStackView.isHidden = true
            case .notAvailable:
                self.activeStackView.isHidden = true
                self.notActiveStackView.isHidden = true
                self.selectPeriodStackView.isHidden = true
            case .notActive:
                self.activeStackView.isHidden = true
                self.notActiveStackView.isHidden = false
                self.selectPeriodStackView.isHidden = true
            case .selectingPeriod:
                self.activeStackView.isHidden = true
                self.notActiveStackView.isHidden = true
                self.selectPeriodStackView.isHidden = false
            case .active:
                self.activeStackView.isHidden = false
                self.notActiveStackView.isHidden = true
                self.selectPeriodStackView.isHidden = true
        }
    }
    
    @IBAction func switchToPeriodSelection() {
        self.viewModel.switchToPeriodSelection()
        updateView()
    }
    
    @IBAction func selectOneDay() {
        self.viewModel.activateLinkSharing(period: .oneDay) {
            DispatchQueue.dispatchOnMainThread {
                self.updateView()
            }
        }
    }

    @IBAction func selectOneWeek() {
        self.viewModel.activateLinkSharing(period: .oneWeek) {
            DispatchQueue.dispatchOnMainThread {
                self.updateView()
            }
        }
    }

    @IBAction func selectOneMonth() {
        self.viewModel.activateLinkSharing(period: .oneMonth) {
            DispatchQueue.dispatchOnMainThread {
                self.updateView()
            }
        }
    }
    
    @IBAction func cancelPeriodSelection() {
        self.viewModel.cancelPeriodSelection()
        updateView()
    }

    @IBAction func shareLink() {
        guard let link = viewModel.link?.url,
              let linkUrl = URL(string: link) else {
                  return
              }
        let items = [linkUrl, "Text to share"] as [Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func revokeLink() {
        self.viewModel.revokeLink {
            DispatchQueue.dispatchOnMainThread {
                self.updateView()
            }
        }
    }
}
