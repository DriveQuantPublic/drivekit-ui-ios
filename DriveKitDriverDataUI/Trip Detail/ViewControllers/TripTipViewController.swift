// swiftlint:disable no_magic_numbers
//
//  TripTipViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 30/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule
import DriveKitCommonUI

class TripTipViewController: DKUIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var evaluationButtons: UIStackView!
    
    @IBOutlet var yesButtonView: UIView!
    @IBOutlet var yesImage: UIImageView!
    @IBOutlet var yesLabel: UILabel!
    
    @IBOutlet var noButtonView: UIView!
    @IBOutlet var noImage: UIImageView!
    @IBOutlet var noLabel: UILabel!
    
    private let advice: DKTripAdvice
    private let trip: DKTrip
    private let tripDetailVC: TripDetailVC
    
    init(trip: DKTrip, advice: DKTripAdvice, tripDetailVC: TripDetailVC) {
        self.trip = trip
        self.tripDetailVC = tripDetailVC
        self.advice = advice
        super.init(nibName: String(describing: TripTipViewController.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureHeaderNavigation()
        self.configureAdvice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.advice.evaluation != 0 || !DriveKitDriverDataUI.shared.enableAdviceFeedback {
            evaluationButtons.isHidden = true
            closeButton.isHidden = false
            self.configureCloseButton()
        } else {
            evaluationButtons.isHidden = false
            closeButton.isHidden = true
            self.configureNoButton()
            self.configureYesButton()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let theme = self.advice.theme {
            if theme == "ECODRIVING" {
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_trips_detail_advice_efficiency", viewController: self)
            } else if theme == "SAFETY" {
                DriveKitUI.shared.trackScreen(tagKey: "dk_tag_trips_detail_advice_safety", viewController: self)
            }
        }
    }
    
    func configureCloseButton() {
        closeButton.setAttributedTitle(
            DKCommonLocalizable.ok.text()
                .dkAttributedString()
                .font(dkFont: .primary, style: .button)
                .color(.fontColorOnSecondaryColor)
                .uppercased()
                .build(),
            for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = DKUIColors.secondaryColor.color
    }
    
    func configureHeaderNavigation() {
        self.title = advice.title ?? ""
    }
    
    func configureAdvice() {
        let contentTextView = UITextView(frame: contentView.frame)

        if let htmlData = (advice.message ?? "").data(using: .unicode) {
            do {
                let attributedString = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                contentTextView.attributedText = NSAttributedString(attributedString: attributedString)
                contentTextView.font = DKUIFonts.primary.fonts(size: 16)
                contentTextView.isEditable = false
                contentTextView.backgroundColor = DKUIColors.backgroundView.color
                contentView.embedSubview(contentTextView)
            } catch {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func configureYesButton() {
        yesImage.image = DKDriverDataImages.adviceAgree.image?.withRenderingMode(.alwaysTemplate)
        yesImage.tintColor = DKUIColors.primaryColor.color
        yesLabel.attributedText = 
        "dk_driverdata_advice_agree"
            .dkDriverDataLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: getButtonStyle())
            .uppercased()
            .color(.primaryColor)
            .build()

        yesButtonView.isUserInteractionEnabled = true
        let yesButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnYesButton(_:)))
        yesButtonView.addGestureRecognizer(yesButtonGesture)
    }

    @objc func tapOnYesButton(_ sender: UITapGestureRecognizer) {
        let feedbackViewModel = TripTipFeedbackViewModel(trip: self.trip, tripAdvice: self.advice)
        feedbackViewModel.evaluation = 1
        feedbackViewModel.itinId = self.trip.itinId

        feedbackViewModel.sendFeedback(completion: { status in
            if status {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: "dk_driverdata_advice_feedback_success".dkDriverDataLocalized(), back: true, cancel: false, completion: {
                        DriveKitDriverData.shared.getTrip(itinId: self.trip.itinId, completionHandler: { _, trip in
                            self.tripDetailVC.viewModel.trip = trip
                        })
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: "dk_driverdata_advice_feedback_error".dkDriverDataLocalized(), back: false, cancel: false)
                }
            }
        })
    }

    func configureNoButton() {
        noImage.image = DKDriverDataImages.adviceDisagree.image?.withRenderingMode(.alwaysTemplate)
        noImage.tintColor = DKUIColors.primaryColor.color
        noLabel.attributedText = "dk_driverdata_advice_disagree"
            .dkDriverDataLocalized()
            .dkAttributedString()
            .font(dkFont: .primary, style: getButtonStyle())
            .uppercased()
            .color(.primaryColor)
            .build()

        noButtonView.isUserInteractionEnabled = true
        let noButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnNoButton(_:)))
        noButtonView.addGestureRecognizer(noButtonGesture)
    }

    @objc func tapOnNoButton(_ sender: UITapGestureRecognizer) {
        let feedbackViewModel = TripTipFeedbackViewModel(
            trip: self.trip,
            tripAdvice: self.advice
        )
        if let feedbackVC = UIStoryboard.init(
            name: String(describing: TripTipFeedbackVC.self),
            bundle: Bundle.driverDataUIBundle
        ).instantiateViewController(
            withIdentifier: String(describing: TripTipFeedbackVC.self)) as? TripTipFeedbackVC {
            feedbackVC.configure(viewModel: feedbackViewModel, tripDetailVC: self.tripDetailVC)
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }

    @IBAction func tapOnCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private func getButtonStyle() -> DKStyle {
        return DKStyle(size: DKStyles.bigtext.style.size, traits: .traitBold)
    }

}
