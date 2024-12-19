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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
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
        self.view.backgroundColor = DKUIColors.backgroundView.color
        
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
        self.shareLinkButton.configure(title: "dk_location_sharing_active_share_link".dkTripAnalysisLocalized(), style: .full)
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
        self.descriptionLabel.attributedText = self.viewModel.getAttributedText(for: status)
        self.descriptionImage.image = self.viewModel.getImage(for: status)
    }
    
    @IBAction func switchToPeriodSelection() {
        self.viewModel.switchToPeriodSelection()
        updateView()
    }
    
    @IBAction func selectOneDay() {
        showLoader()
        self.viewModel.activateLinkSharing(period: .oneDay) {success in
            self.updateViewAndHideLoader(showError: !success)
        }
    }

    @IBAction func selectOneWeek() {
        showLoader()
        self.viewModel.activateLinkSharing(period: .oneWeek) {success in 
            self.updateViewAndHideLoader(showError: !success)
        }
    }

    @IBAction func selectOneMonth() {
        showLoader()
        self.viewModel.activateLinkSharing(period: .oneMonth) {success in 
            self.updateViewAndHideLoader(showError: !success)
        }
    }
    
    private func showErrorPopup() {
        let alert = UIAlertController(title: "", message: DKCommonLocalizable.error.text(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelPeriodSelection() {
        self.viewModel.cancelPeriodSelection()
        updateView()
    }

    @IBAction func shareLink() {
        let ac = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func revokeLink() {
        let alert = UIAlertController(title: nil,
                                      message: "dk_location_sharing_active_disable_confirmation".dkTripAnalysisLocalized(),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let revokeAction = UIAlertAction(title: "dk_location_sharing_active_disable".dkTripAnalysisLocalized(), style: .destructive, handler: {[weak self] _ in
            self?.showLoader()
            self?.viewModel.revokeLink { success in
                self?.updateViewAndHideLoader(showError: !success)
            }
        })
        alert.addAction(revokeAction)
        self.present(alert, animated: true)
    }
    
    private func updateViewAndHideLoader(showError: Bool = false) {
        DispatchQueue.dispatchOnMainThread {
            self.updateView()
            self.hideLoader()
            if showError {
                self.showErrorPopup()
            }
        }
    }
}

extension TripSharingViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "dk_location_sharing_sharesheet_title".dkTripAnalysisLocalized()
    }
        
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let link = viewModel.link?.url,
              let linkUrl = URL(string: link) else {
                  return nil
        }
        if activityType == .copyToPasteboard {
            return linkUrl
        } else {
            let appName: String = Bundle.main.appName ?? ""
            let textToShare = String(format: "dk_location_sharing_sharesheet_content".dkTripAnalysisLocalized(), appName, link)
            return textToShare
        }
    }
}
