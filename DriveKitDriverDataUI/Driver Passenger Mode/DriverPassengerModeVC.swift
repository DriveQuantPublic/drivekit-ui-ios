//
//  DriverPassengerModeVC.swift
//  DriveKitDriverDataUI
//
//  Created by Amine Gahbiche on 21/07/2025.
//  Copyright © 2025 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

class DriverPassengerModeVC: DKUIViewController {
    private let maxCommentLength = 120
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageBackground: UIView!
    @IBOutlet private weak var transportationModeTitle: UILabel!
    @IBOutlet private weak var busTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var trainTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var bikeTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var boatTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var planeTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var onFootTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var passengerDriverTitle: UILabel!
    @IBOutlet private weak var driverButton: TransportationModeIcon!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var passengerButton: TransportationModeIcon!
    @IBOutlet private weak var passengerLabel: UILabel!
    @IBOutlet private weak var commentTitle: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var commentError: UILabel!
    @IBOutlet private weak var validateButton: UIButton!
    
    private var selectedModeButton: TransportationModeIcon?
    
    private let viewModel: DriverPassengerModeViewModel
    private weak var parentView: UIViewController?
    
    init(viewModel: DriverPassengerModeViewModel, parent: UIViewController) {
        self.viewModel = viewModel
        self.parentView = parent
        super.init(nibName: String(describing: DriverPassengerModeVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.busTransportationModeButton.image = DKDriverDataImages.transportationBus.image
        self.trainTransportationModeButton.image = DKDriverDataImages.transportationTrain.image
        self.bikeTransportationModeButton.image = DKDriverDataImages.transportationBicyle.image
        self.boatTransportationModeButton.image = DKDriverDataImages.transportationBoat.image
        self.planeTransportationModeButton.image = DKDriverDataImages.transportationPlane.image
        self.onFootTransportationModeButton.image = DKDriverDataImages.transportationOnFoot.image
        self.driverButton.image = DKDriverDataImages.transportationDriver.image
        self.driverLabel.attributedText = "dk_driverdata_transportation_profile_driver".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.passengerButton.image = DKDriverDataImages.transportationPassenger.image
        self.passengerLabel.attributedText = "dk_driverdata_transportation_profile_passenger".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()

        self.title = "dk_driverdata_ocupant_declaration_title".dkDriverDataLocalized()
        
        self.messageLabel.attributedText = self.viewModel.getMessageAttributedText()
        self.messageBackground.backgroundColor = DKUIColors.warningColor.color
        self.messageBackground.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius

        self.transportationModeTitle.attributedText = "dk_driverdata_ocupant_declaration_transportation_question".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.passengerDriverTitle.attributedText = "dk_driverdata_ocupant_declaration_role_question".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.commentTitle.attributedText = "dk_driverdata_transportation_mode_declaration_comment".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.commentError.attributedText = "dk_driverdata_transportation_mode_declaration_comment_error".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.criticalColor).build()
        self.commentTextView.text = self.viewModel.comment
        self.commentTextView.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentTextView.layer.cornerRadius = DKUIConstants.UIStyle.cornerRadius
        self.commentTextView.delegate = self
        
        let transportationModeButtons: [TransportationModeIcon] = [
            self.busTransportationModeButton,
            self.trainTransportationModeButton,
            self.bikeTransportationModeButton,
            self.boatTransportationModeButton,
            self.planeTransportationModeButton,
            self.onFootTransportationModeButton
        ]
        for transportationModeButton in transportationModeButtons {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transportationModeDidTouch(sender:)))
            transportationModeButton.addGestureRecognizer(tapGestureRecognizer)
        }
        
        self.driverButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(driverButtonDidTouch)))
        self.passengerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passengerButtonDidTouch)))

        self.validateButton.configure(title: self.viewModel.getActionButtonTitle(), style: .full)

        updateState()
    }
    
    @objc private func transportationModeDidTouch(sender: UITapGestureRecognizer) {
        if let transportationMode = sender.view as? TransportationModeIcon {
            selectTransportationMode(transportationMode)
        }
    }

    @objc private func driverButtonDidTouch() {
        selectDriverMode(true)
    }

    @objc private func passengerButtonDidTouch() {
        selectPassengerMode(true)
    }

    @objc private func selectDriverMode(_ update: Bool = true) {
        self.selectedModeButton?.isSelected = false
        self.driverButton.isSelected = true
        self.selectedModeButton = self.driverButton
        if update {
            self.viewModel.passenger = false
            self.viewModel.selectedTransportationMode = .car
        }
    }
    
    @objc private func selectPassengerMode(_ update: Bool = true) {
        self.selectedModeButton?.isSelected = false
        self.passengerButton.isSelected = true
        self.selectedModeButton = self.passengerButton
        if update {
            self.viewModel.passenger = true
            self.viewModel.selectedTransportationMode = .car
        }
    }
    
    private func selectTransportationMode(_ transportationMode: TransportationModeIcon, update: Bool = true) {
        self.selectedModeButton?.isSelected = false
        transportationMode.isSelected = true
        self.selectedModeButton = transportationMode
        
        if update {
            let newTransportationMode: TransportationMode?
            switch transportationMode {
                case self.busTransportationModeButton:
                    newTransportationMode = .bus
                case self.trainTransportationModeButton:
                    newTransportationMode = .train
                case self.bikeTransportationModeButton:
                    newTransportationMode = .bike
                case self.boatTransportationModeButton:
                    newTransportationMode = .boat
                case self.planeTransportationModeButton:
                    newTransportationMode = .flight
                case self.onFootTransportationModeButton:
                    newTransportationMode = .onFoot
                default:
                    newTransportationMode = nil
            }
            if self.viewModel.declaredTransportationMode() != newTransportationMode {
                self.viewModel.selectedTransportationMode = newTransportationMode
                self.viewModel.passenger = nil
                updateState()
            }
        }
    }
    
    private func updateState() {
        if self.isViewLoaded, let selectedTransportationMode = self.viewModel.selectedTransportationMode {
            switch selectedTransportationMode {
                case .bike:
                    selectTransportationMode(self.bikeTransportationModeButton, update: false)
                case .boat:
                    selectTransportationMode(self.boatTransportationModeButton, update: false)
                case .bus:
                    selectTransportationMode(self.busTransportationModeButton, update: false)
                case .flight:
                    selectTransportationMode(self.planeTransportationModeButton, update: false)
                case .onFoot:
                    selectTransportationMode(self.onFootTransportationModeButton, update: false)
                case .train:
                    selectTransportationMode(self.trainTransportationModeButton, update: false)
                case .car:
                    if let passenger = self.viewModel.passenger {
                        if passenger == true {
                            selectPassengerMode(false)
                        } else {
                            selectDriverMode(false)
                        }
                    }
                case .unknown, .moto, .truck, .skiing, .idle, .other:
                    break
                @unknown default:
                    break
            }
        }
    }
    
    @IBAction private func validate() {
        let comment: String = self.commentTextView.text
        let commentTextLength = comment.count
        if commentTextLength <= self.maxCommentLength {
            showLoader()
            if self.viewModel.selectedTransportationMode == .car {
                self.viewModel.declareDriverPassengerMode { [weak self] status in
                    DispatchQueue.main.async {
                        if let self = self {
                            switch status {
                                case .success:
                                    if let tripDetailVC = self.parentView as? TripDetailVC {
                                        DriveKitDriverData.shared.getTrip(itinId: self.viewModel.itinId, completionHandler: { _, trip in
                                            tripDetailVC.viewModel.trip = trip
                                            tripDetailVC.setupDriverPassengerButton()
                                        })
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                case .failedToUpdateMode, .invalidItineraryId, .invalidTransportationMode, .userNotConnected:
                                    self.showAlertMessage(
                                        title: nil,
                                        message: "dk_driverdata_failed_to_declare_transportation".dkDriverDataLocalized(),
                                        back: false,
                                        cancel: false
                                    )
                                case .commentTooLong:
                                    self.showAlertMessage(
                                        title: nil,
                                        message: "dk_driverdata_transportation_mode_declaration_comment_error".dkDriverDataLocalized(),
                                        back: false,
                                        cancel: false
                                    )
                                @unknown default:
                                    break
                            }
                        }
                    }
                }
            } else {
                self.viewModel.declareTransportationMode { [weak self] status in
                    DispatchQueue.main.async {
                        if let self = self {
                            switch status {
                                case .noError:
                                    if let tripDetailVC = self.parentView as? TripDetailVC {
                                        DriveKitDriverData.shared.getTrip(itinId: self.viewModel.itinId, completionHandler: { _, trip in
                                            tripDetailVC.viewModel.trip = trip
                                            tripDetailVC.setupDriverPassengerButton()
                                        })
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                case .failedToDeclareTransportationMode:
                                    self.showAlertMessage(
                                        title: nil,
                                        message: "dk_driverdata_failed_to_declare_transportation".dkDriverDataLocalized(),
                                        back: false,
                                        cancel: false
                                    )
                                case .commentTooLong:
                                    self.showAlertMessage(
                                        title: nil,
                                        message: "dk_driverdata_transportation_mode_declaration_comment_error".dkDriverDataLocalized(),
                                        back: false,
                                        cancel: false
                                    )
                                @unknown default:
                                    break
                            }
                        }
                    }
                }
            }
        }
    }
}

extension DriverPassengerModeVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.commentError.isHidden = textView.text.count <= self.maxCommentLength
    }
}
