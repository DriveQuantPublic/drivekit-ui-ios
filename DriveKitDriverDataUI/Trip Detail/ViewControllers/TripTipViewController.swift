//
//  TripTipViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 30/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDBTripAccess
import DriveKitDriverData
import DriveKitCommonUI

class TripTipViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var evaluationButtons: UIStackView!
    
    @IBOutlet var yesButtonView: UIView!
    @IBOutlet var yesImage: UIImageView!
    @IBOutlet var yesLabel: UILabel!
    
    @IBOutlet var noButtonView: UIView!
    @IBOutlet var noImage: UIImageView!
    @IBOutlet var noLabel: UILabel!
    
    private let detailConfig: TripDetailViewConfig
    private let advice: TripAdvice
    private let trip: Trip
    private let tripDetailVC: TripDetailVC
    
    init(trip: Trip, advice: TripAdvice, tripDetailVC: TripDetailVC, detailConfig: TripDetailViewConfig) {
        self.trip = trip
        self.tripDetailVC = tripDetailVC
        self.detailConfig = detailConfig
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
        if self.advice.evaluation != 0 {
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
    
    func configureCloseButton() {
        closeButton.setTitle(DKCommonLocalizable.ok.text(), for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = DKUIColors.secondaryColor.color
    }
    
    func configureHeaderNavigation() {
        self.title = advice.title ?? ""
    }
    
    func configureAdvice() {
        let contentTextView = UITextView(frame: contentView.frame)
        self.automaticallyAdjustsScrollViewInsets = false

        if let htmlData = NSString(string: advice.message ?? "").data(using: String.Encoding.unicode.rawValue){
            let attributedString = try! NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            contentTextView.attributedText = NSAttributedString(attributedString: attributedString)
            contentTextView.font = DKUIFonts.primary.fonts(size: 16)
            contentTextView.isEditable = false
            contentView.embedSubview(contentTextView)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    func configureYesButton() {
        yesImage.image = UIImage(named: "dk_advice_agree", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        yesImage.tintColor = .black
        yesLabel.text = detailConfig.adviceAgreeText
        
        yesButtonView.isUserInteractionEnabled = true
        let yesButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnYesButton(_:)))
        yesButtonView.addGestureRecognizer(yesButtonGesture)
    }
    
    @objc func tapOnYesButton(_ sender: UITapGestureRecognizer)  {
        let feedbackViewModel = TripTipFeedbackViewModel(trip: self.trip, tripAdvice: self.advice, detailConfig: self.detailConfig)
        feedbackViewModel.evaluation = 1
        feedbackViewModel.itinId = self.trip.itinId ?? ""
        
        feedbackViewModel.sendFeedback(completion: { status in
            if status {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: self.detailConfig.adviceFeedbackSuccessText, back: true, cancel: false, completion: {
                        DriveKitDriverData.shared.getTrip(itinId: self.trip.itinId ?? "", completionHandler: { status, trip in
                            self.tripDetailVC.viewModel.trip = trip
                        })
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: self.detailConfig.adviceFeedbackErrorText, back: false, cancel: false)
                }
            }
        })
    }
    func configureNoButton() {
        noImage.image = UIImage(named: "dk_advice_disagree", in: Bundle.driverDataUIBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        noImage.tintColor = .black
        noLabel.text = detailConfig.adviceDisagreeText
                
        noButtonView.isUserInteractionEnabled = true
        let noButtonGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnNoButton(_:)))
        noButtonView.addGestureRecognizer(noButtonGesture)
    }
    
    @objc func tapOnNoButton(_ sender: UITapGestureRecognizer)  {
        let feedbackViewModel = TripTipFeedbackViewModel(trip: self.trip, tripAdvice: self.advice, detailConfig: self.detailConfig)
        if let feedbackVC = UIStoryboard.init(name: String(describing: TripTipFeedbackVC.self), bundle: Bundle.driverDataUIBundle).instantiateViewController(withIdentifier: String(describing: TripTipFeedbackVC.self)) as? TripTipFeedbackVC {
            feedbackVC.configure(viewModel: feedbackViewModel, tripDetailVC: self.tripDetailVC)
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    @IBAction func tapOnCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
