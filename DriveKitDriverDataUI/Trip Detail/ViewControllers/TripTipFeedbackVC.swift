//
//  TripTipFeedbackVC.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 06/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDriverDataModule
import DriveKitCommonUI

class TripTipFeedbackVC: UITableViewController {
    @IBOutlet private var contentLabel: UILabel!
    @IBOutlet private var commentTextView: UITextView!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var cancelButton: UIButton!

    @IBOutlet private var feedbackLabel1: UILabel!
    @IBOutlet private var feedbackLabel2: UILabel!
    @IBOutlet private var feedbackLabel3: UILabel!
    @IBOutlet private var feedbackLabel4: UILabel!
    @IBOutlet private var feedbackLabel5: UILabel!

    var viewModel: TripTipFeedbackViewModel!
    var tripDetailVC: TripDetailVC?

    private let commentChoice = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DKUIColors.backgroundView.color
        self.title = viewModel?.title
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.tintColor = DKUIColors.secondaryColor.color
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
        configureBackButton()
        self.configureContent()
        self.configureFeedbacks()
        self.configureSend()
        self.configureCancel()
        self.configureComment()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        updateStates()
    }
    
    func configure(viewModel: TripTipFeedbackViewModel, tripDetailVC: TripDetailVC) {
        self.viewModel = viewModel
        self.tripDetailVC = tripDetailVC
    }

    private func configureBackButton() {
        DKUIViewController.configureBackButton(viewController: self, selector: #selector(onBack))
    }

    @objc private func onBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let choice = self.viewModel.selectedChoice
        if choice != self.viewModel.noChoice {
            self.viewModel.evaluation = 2
            self.viewModel.feedBack = choice
            switch choice {
                case 0:
                    self.viewModel.comment = "dk_driverdata_advice_feedback_01".dkDriverDataLocalized()
                case 1:
                    self.viewModel.comment = "dk_driverdata_advice_feedback_02".dkDriverDataLocalized()
                case 2:
                    self.viewModel.comment = "dk_driverdata_advice_feedback_03".dkDriverDataLocalized()
                case 3:
                    self.viewModel.comment = "dk_driverdata_advice_feedback_04".dkDriverDataLocalized()
                case commentChoice:
                    self.viewModel.comment = self.commentTextView.text
                default:
                    break
            }

            self.viewModel.sendFeedback( completion: { status in
                if status {
                    DispatchQueue.main.async {
                        self.showAlertMessage(title: nil, message: "dk_driverdata_advice_feedback_success".dkDriverDataLocalized(), back: true, cancel: false, completion: {
                            DriveKitDriverData.shared.getTrip(itinId: self.viewModel.itinId, completionHandler: { _, trip in
                                self.tripDetailVC?.viewModel.trip = trip
                            })
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                         self.showAlertMessage(title: nil, message: "dk_driverdata_advice_feedback_error".dkDriverDataLocalized(), back: false, cancel: true)
                    }
                }
            })
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row < 6 {
            viewModel.selectedChoice = indexPath.row - 1
            tableView.cellForRow(at: indexPath as IndexPath)?.tintColor = DKUIColors.secondaryColor.color
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
            updateStates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row < 6 {
            self.viewModel.clearSelectedChoice()
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            updateStates()
        }
    }

    private func updateStates() {
        let choice = self.viewModel.selectedChoice
        self.sendButton.isEnabled = choice != self.viewModel.noChoice
        self.commentTextView.isHidden = choice != commentChoice
    }
}

fileprivate extension TripTipFeedbackVC {
    func configureContent() {
        contentLabel.attributedText = viewModel.content.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    func configureFeedbacks() {
        self.feedbackLabel1.attributedText = viewModel.choices[0].dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.feedbackLabel2.attributedText = viewModel.choices[1].dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.feedbackLabel3.attributedText = viewModel.choices[2].dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.feedbackLabel4.attributedText = viewModel.choices[3].dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
        self.feedbackLabel5.attributedText = viewModel.choices[4].dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    func configureComment() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: DKCommonLocalizable.ok.text(), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        commentTextView.font = DKStyles.normalText.withSizeDelta(-2).applyTo(font: .primary)
        commentTextView.inputAccessoryView = doneToolBar
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = DKUIColors.mainFontColor.color.cgColor
        commentTextView.layer.cornerRadius = 5
    }

    @objc func doneButtonAction() {
        commentTextView.resignFirstResponder()
    }

    func configureSend() {
        let title = self.viewModel.send
        sendButton.setAttributedTitle(title.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
        sendButton.setAttributedTitle(title.dkAttributedString().font(dkFont: .primary, style: .button).color(.systemGray).uppercased().build(), for: .disabled)
    }

    func configureCancel() {
        cancelButton.setAttributedTitle(self.viewModel.cancel.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
    }
}
