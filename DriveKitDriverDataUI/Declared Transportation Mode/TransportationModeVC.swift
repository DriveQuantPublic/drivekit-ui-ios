//
//  TransportationModeVC.swift
//  IFPClient
//
//  Created by David Bauduin on 03/08/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule
import DriveKitDriverDataModule

class TransportationModeVC: DKUIViewController {
    private let maxCommentLength = 120
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageBackground: UIView!
    @IBOutlet private weak var transportationModeTitle: UILabel!
    @IBOutlet private weak var transportationModeValue: UILabel!
    @IBOutlet private weak var carTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var motoTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var truckTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var busTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var trainTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var bikeTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var boatTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var planeTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var onFootTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var skiingTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var idleTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var otherTransportationModeButton: TransportationModeIcon!
    @IBOutlet private weak var passengerDriverTitle: UILabel!
    @IBOutlet private weak var passengerDriverButtonsContainer: UIView!
    @IBOutlet private weak var driverButton: TransportationModeIcon!
    @IBOutlet private weak var passengerButton: TransportationModeIcon!
    @IBOutlet private weak var commentTitle: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var commentError: UILabel!
    @IBOutlet private weak var validateButton: UIButton!
    
    private var selectedTransportationModeButton: TransportationModeIcon? = nil
    private var selectedPassengerDriverButton: TransportationModeIcon? = nil
    
    private let viewModel: TransportationModeViewModel
    private weak var parentView : UIViewController?
    
    init(viewModel: TransportationModeViewModel, parent: UIViewController) {
        self.viewModel = viewModel
        self.parentView = parent
        super.init(nibName: String(describing: TransportationModeVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "dk_driverdata_transportation_mode_title".dkDriverDataLocalized()
        
        self.messageLabel.attributedText = "dk_driverdata_transportation_mode_declaration_text".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.white).build()
        self.messageBackground.backgroundColor = DKUIColors.warningColor.color
        self.messageBackground.layer.cornerRadius = 4
        
        self.transportationModeTitle.attributedText = "dk_driverdata_transportation_mode".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.passengerDriverTitle.attributedText = "dk_driverdata_transportation_mode_passenger_driver".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.passengerDriverTitle.isHidden = true
        self.passengerDriverButtonsContainer.isHidden = true
        self.commentTitle.attributedText = "dk_driverdata_transportation_mode_declaration_comment".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.mainFontColor).build()
        self.commentError.attributedText = "dk_driverdata_transportation_mode_declaration_comment_error".dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: .driverDataText).color(.criticalColor).build()
        self.commentTextView.text = self.viewModel.comment
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentTextView.layer.cornerRadius = 4
        self.commentTextView.delegate = self
        
        let transportationModeButtons: [TransportationModeIcon] = [self.carTransportationModeButton, self.motoTransportationModeButton, self.truckTransportationModeButton, self.busTransportationModeButton, self.trainTransportationModeButton, self.bikeTransportationModeButton, self.boatTransportationModeButton, self.planeTransportationModeButton, self.onFootTransportationModeButton, self.skiingTransportationModeButton, self.idleTransportationModeButton, self.otherTransportationModeButton]
        for transportationModeButton in transportationModeButtons {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transportationModeDidTouch(sender:)))
            transportationModeButton.addGestureRecognizer(tapGestureRecognizer)
        }
        
        self.driverButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(driverButtonDidTouch)))
        self.passengerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passengerButtonDidTouch)))

        self.validateButton.configure(text: DKCommonLocalizable.validate.text(), style: .full)

        updateState()
    }
    
    @objc private func transportationModeDidTouch(sender: UITapGestureRecognizer) {
        if let transportationMode = sender.view as? TransportationModeIcon {
            selectTransportationMode(transportationMode)
        }
    }
    
    @objc private func driverButtonDidTouch() {
        self.selectedPassengerDriverButton?.isSelected = false
        self.driverButton.isSelected = true
        self.selectedPassengerDriverButton = self.driverButton
    }
    
    @objc private func passengerButtonDidTouch() {
        self.selectedPassengerDriverButton?.isSelected = false
        self.passengerButton.isSelected = true
        self.selectedPassengerDriverButton = self.passengerButton
    }
    
    private func selectTransportationMode(_ transportationMode: TransportationModeIcon, update: Bool = true) {
        self.selectedTransportationModeButton?.isSelected = false
        transportationMode.isSelected = true
        self.selectedTransportationModeButton = transportationMode
        
        if transportationMode == self.carTransportationModeButton {
            if let isPassenger = self.viewModel.isPassenger {
                if isPassenger {
                    passengerButtonDidTouch()
                } else {
                    driverButtonDidTouch()
                }
            }
            self.passengerDriverTitle.isHidden = false
            self.passengerDriverButtonsContainer.isHidden = false
        } else {
            self.selectedPassengerDriverButton?.isSelected = false
            self.selectedPassengerDriverButton = nil
            self.passengerDriverTitle.isHidden = true
            self.passengerDriverButtonsContainer.isHidden = true
        }
        
        if update {
            let newTransportationMode: TransportationMode
            switch transportationMode {
                case self.carTransportationModeButton:
                    newTransportationMode = .car
                case self.motoTransportationModeButton:
                    newTransportationMode = .moto
                case self.truckTransportationModeButton:
                    newTransportationMode = .truck
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
                case self.skiingTransportationModeButton:
                    newTransportationMode = .skiing
                case self.idleTransportationModeButton:
                    newTransportationMode = .idle
                case self.otherTransportationModeButton:
                    newTransportationMode = .other
                default:
                    newTransportationMode = .car
            }
            if self.viewModel.declaredTransportationMode() != newTransportationMode {
                self.viewModel.selectedTransportationMode = newTransportationMode
                updateState()
            }
        }
    }
    
    private func updateState() {
        if self.isViewLoaded, let selectedTransportationMode = self.viewModel.selectedTransportationMode {
            let titleKey = selectedTransportationMode.getName()
            switch selectedTransportationMode {
                case .bike:
                    selectTransportationMode(self.bikeTransportationModeButton, update: false)
                case .boat:
                    selectTransportationMode(self.boatTransportationModeButton, update: false)
                case .bus:
                    selectTransportationMode(self.busTransportationModeButton, update: false)
                case .car:
                    selectTransportationMode(self.carTransportationModeButton, update: false)
                case .flight:
                    selectTransportationMode(self.planeTransportationModeButton, update: false)
                case .idle:
                    selectTransportationMode(self.idleTransportationModeButton, update: false)
                case .moto:
                    selectTransportationMode(self.motoTransportationModeButton, update: false)
                case .onFoot:
                    selectTransportationMode(self.onFootTransportationModeButton, update: false)
                case .other, .unknown:
                    selectTransportationMode(self.otherTransportationModeButton, update: false)
                case .skiing:
                    selectTransportationMode(self.skiingTransportationModeButton, update: false)
                case .train:
                    selectTransportationMode(self.trainTransportationModeButton, update: false)
                case .truck:
                    selectTransportationMode(self.truckTransportationModeButton, update: false)
                @unknown default:
                    break
            }
            let detectionModeStyle = DKStyle(size: 14, traits: UIFontDescriptor.SymbolicTraits.traitBold)
            self.transportationModeValue.attributedText = titleKey.dkDriverDataLocalized().dkAttributedString().font(dkFont: .primary, style: detectionModeStyle).color(.primaryColor).build()
        }
    }
    
    @IBAction private func validate() {
        if let selectedTransportationMode = self.viewModel.selectedTransportationMode {
            let comment: String = self.commentTextView.text
            let commentTextLength = comment.count
            if commentTextLength <= self.maxCommentLength {
                var passenger: Bool? = nil
                if selectedTransportationMode == .car {
                    if let selectedPassengerDriverButton = self.selectedPassengerDriverButton {
                        if selectedPassengerDriverButton == self.driverButton {
                            passenger = false
                        } else {
                            passenger = true
                        }
                    }
                }
                if let itinId = self.viewModel.itinId {
                    showLoader()
                    DriveKitDriverData.shared.declareTransportationMode(itinId: itinId, mode: selectedTransportationMode, passenger: passenger ?? false, comment: comment, completionHandler: { [weak self] status in
                        DispatchQueue.main.async {
                            if let self = self {
                                switch status {
                                    case .noError:
                                        if let parentView = self.parentView, parentView is AlternativeTripDetailInfoVC {
                                            (parentView as! AlternativeTripDetailInfoVC).update()
                                        }
                                        self.navigationController?.popViewController(animated: true)
                                    case .failedToDeclareTransportationMode:
                                        self.showAlertMessage(title: nil, message: "dk_driverdata_failed_to_declare_transportation".dkDriverDataLocalized(), back: false, cancel: false)
                                    case .commentTooLong:
                                        self.showAlertMessage(title: nil, message: "dk_driverdata_transportation_mode_declaration_comment_error".dkDriverDataLocalized(), back: false, cancel: false)
                                    @unknown default:
                                        break
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}


extension TransportationModeVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.commentError.isHidden = textView.text.count <= self.maxCommentLength
    }
    
}
