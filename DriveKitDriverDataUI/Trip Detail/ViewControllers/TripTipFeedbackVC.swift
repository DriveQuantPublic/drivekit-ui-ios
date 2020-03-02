//
//  TripTipFeedbackVC.swift
//  DriveKitDriverDataUI
//
//  Created by Meryl Barantal on 06/12/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import DriveKitDriverData
import DriveKitCommonUI

class TripTipFeedbackVC: UITableViewController {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var feedbackLabel1: UILabel!
    @IBOutlet var feedbackLabel2: UILabel!
    @IBOutlet var feedbackLabel3: UILabel!
    @IBOutlet var feedbackLabel4: UILabel!
    @IBOutlet var feedbackLabel5: UILabel!
    
    var viewModel: TripTipFeedbackViewModel!
    var tripDetailVC: TripDetailVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.tintColor = DKUIColors.secondaryColor.color
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
        self.configureContent()
        self.configureFeedbacks()
        self.configureSend()
        self.configureCancel()
        self.configureComment()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func configure(viewModel: TripTipFeedbackViewModel, tripDetailVC: TripDetailVC) {
        self.viewModel = viewModel
        self.tripDetailVC = tripDetailVC
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.viewModel.evaluation = 2
        self.viewModel.feedBack = self.viewModel.selectedChoice
        switch self.viewModel.feedBack {
            case 0:
                self.viewModel.comment = "dk_advice_feedback_01".dkDriverDataLocalized()
            case 1:
                self.viewModel.comment = "dk_advice_feedback_02".dkDriverDataLocalized()
            case 2:
                self.viewModel.comment = "dk_advice_feedback_03".dkDriverDataLocalized()
            case 3:
                self.viewModel.comment = "dk_advice_feedback_04".dkDriverDataLocalized()
            case 4:
                self.viewModel.comment = self.commentTextView.text
        default:
            break
        }
        
        let alert = UIAlertController(title: nil,
                                      message: "dk_advice_feedback_success".dkDriverDataLocalized(),
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(ok)
        
        self.viewModel.sendFeedback( completion: { status in
            if status {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: "dk_advice_feedback_success".dkDriverDataLocalized(), back: true, cancel: false, completion: {
                        DriveKitDriverData.shared.getTrip(itinId: self.viewModel.itinId, completionHandler: { status, trip in
                            self.tripDetailVC?.viewModel.trip = trip
                        })
                    })
                }
            } else {
                DispatchQueue.main.async {
                     self.showAlertMessage(title: nil, message: "dk_advice_feedback_error".dkDriverDataLocalized(), back: false, cancel: true)
                }
            }
        })
        
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row < 6 {
            viewModel.selectedChoice = indexPath.row - 1
            tableView.cellForRow(at: indexPath as IndexPath)?.tintColor = DKUIColors.secondaryColor.color
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         if indexPath.row > 0 && indexPath.row < 6 {
            viewModel.selectedChoice = 0
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }
    }
    
}

fileprivate extension TripTipFeedbackVC {
    func configureContent() {
        contentLabel.attributedText = viewModel.content.dkAttributedString().font(dkFont: .primary, style: .normalText).color(.mainFontColor).build()
    }
    
    func configureFeedbacks() {
        self.feedbackLabel1.attributedText = viewModel.choices[0].dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.feedbackLabel2.attributedText = viewModel.choices[1].dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.feedbackLabel3.attributedText = viewModel.choices[2].dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.feedbackLabel4.attributedText = viewModel.choices[3].dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
        self.feedbackLabel5.attributedText = viewModel.choices[4].dkAttributedString().font(dkFont: .primary, style: .smallText).color(.mainFontColor).build()
    }
    
    func configureComment() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: DKCommonLocalizable.ok.text(), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        commentTextView.inputAccessoryView = doneToolBar
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = DKUIColors.mainFontColor.color.cgColor
        commentTextView.layer.cornerRadius = 5
    }
    
    @objc func doneButtonAction(){
        commentTextView.resignFirstResponder()
    }
    
    func configureSend(){
        sendButton.setAttributedTitle(self.viewModel.send.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
    }
    
    func configureCancel(){
        cancelButton.setAttributedTitle(self.viewModel.cancel.dkAttributedString().font(dkFont: .primary, style: .button).color(.secondaryColor).uppercased().build(), for: .normal)
    }
}
