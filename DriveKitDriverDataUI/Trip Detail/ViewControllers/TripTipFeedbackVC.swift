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
    var detailConfig: TripDetailViewConfig!
    var config: TripListViewConfig!
    var tripDetailVC: TripDetailVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.tintColor = config.secondaryColor
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
        self.config = viewModel.config
        self.detailConfig = viewModel.detailConfig
        self.tripDetailVC = tripDetailVC
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.viewModel.evaluation = 2
        self.viewModel.feedBack = self.viewModel.selectedChoice
        switch self.viewModel.feedBack {
            case 0:
                self.viewModel.comment = detailConfig.adviceFeedbackChoice01Text
            case 1:
                self.viewModel.comment = detailConfig.adviceFeedbackChoice02Text
            case 2:
                self.viewModel.comment = detailConfig.adviceFeedbackChoice03Text
            case 3:
                self.viewModel.comment = detailConfig.adviceFeedbackChoice04Text
            case 4:
                self.viewModel.comment = self.commentTextView.text
        default:
            break
        }
        
        let alert = UIAlertController(title: nil,
                                      message: detailConfig.adviceFeedbackSuccessText,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: config.okText, style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(ok)
        
        self.viewModel.sendFeedback( completion: { status in
            if status {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: nil, message: self.detailConfig.adviceFeedbackSuccessText, back: true, cancel: false, completion: {
                        DriveKitDriverData.shared.getTrip(itinId: self.viewModel.itinId, completionHandler: { status, trip in
                            self.tripDetailVC?.viewModel.trip = trip
                        })
                    })
                }
            } else {
                DispatchQueue.main.async {
                     self.showAlertMessage(title: nil, message: self.detailConfig.adviceFeedbackErrorText, back: false, cancel: true)
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
            tableView.cellForRow(at: indexPath as IndexPath)?.tintColor = config.secondaryColor
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

/*extension TripTipFeedbackVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell : TripTipFeedbackChoicesCell = choicesTableView.dequeueReusableCell(withIdentifier: "TripTipFeedbackChoicesCell") as? TripTipFeedbackChoicesCell {
        let choicesAttribute = [NSAttributedString.Key.foregroundColor: UIColor.dkGrayText]
            let choiceAttributedText = NSAttributedString(string: viewModel.choices[indexPath.row], attributes: choicesAttribute)
            cell.choiceLabel.attributedText = choiceAttributedText
         

            if indexPath.row == 0 {
                tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.tintColor = config.secondaryColor
                tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .checkmark
            }
        
            let row = choicesTableView.dequeueReusableCell(withIdentifier: "TripTipFeedbackChoicesCell", for: indexPath)
            let height = row.bounds.height
            var frame: CGRect = choicesTableView.frame
            frame.size.height = height * CGFloat(viewModel.choices.count)
            choicesTableView.frame = frame
            
            return cell
        } else {
            return UITableViewCell()
        }
        }
}*/

fileprivate extension TripTipFeedbackVC {
    func configureContent() {
        let contentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.dkGrayText]
        let contentAttributedText = NSAttributedString(string: viewModel.content, attributes: contentAttribute)
        contentLabel.attributedText = contentAttributedText
    }
    
    func configureFeedbacks() {
        let choicesAttribute = [NSAttributedString.Key.foregroundColor: UIColor.dkGrayText]
        self.feedbackLabel1.attributedText = NSAttributedString(string: viewModel.choices[0], attributes: choicesAttribute)
        self.feedbackLabel2.attributedText = NSAttributedString(string: viewModel.choices[1], attributes: choicesAttribute)
        self.feedbackLabel3.attributedText = NSAttributedString(string: viewModel.choices[2], attributes: choicesAttribute)
        self.feedbackLabel4.attributedText = NSAttributedString(string: viewModel.choices[3], attributes: choicesAttribute)
        self.feedbackLabel5.attributedText = NSAttributedString(string: viewModel.choices[4], attributes: choicesAttribute)
    }
    
    func configureComment() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: config.okText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        commentTextView.inputAccessoryView = doneToolBar
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.dkGrayText.cgColor
        commentTextView.layer.cornerRadius = 5
    }
    
    @objc func doneButtonAction(){
        commentTextView.resignFirstResponder()
    }
    
    func configureSend(){
        sendButton.setTitle(self.viewModel.send, for: .normal)
        sendButton.setTitleColor(config.secondaryColor, for: .normal)
        sendButton.setTitleColor(UIColor.dkGrayText, for: .disabled)
    }
    
    func configureCancel(){
        cancelButton.setTitle(self.viewModel.cancel, for: .normal)
        cancelButton.setTitleColor(config.secondaryColor, for: .normal)
        cancelButton.setTitleColor(UIColor.dkGrayText, for: .disabled)
    }
}
