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

class TripTipFeedbackVC: UIViewController {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var choicesTableView: UITableView!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var viewModel: TripTipFeedbackViewModel
    var detailConfig: TripDetailViewConfig
    var config: TripListViewConfig
    var tripDetailVC: TripDetailVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.configureContent()
        self.configureSend()
        self.configureCancel()
        self.configureComment()
        choicesTableView.register(TripTipFeedbackChoicesCell.nib, forCellReuseIdentifier: "TripTipFeedbackChoicesCell")
        choicesTableView.delegate = self
        choicesTableView.dataSource = self
    }
    
    init(viewModel: TripTipFeedbackViewModel, tripDetailVC: TripDetailVC) {
        self.viewModel = viewModel
        self.config = viewModel.config
        self.detailConfig = viewModel.detailConfig
        self.tripDetailVC = tripDetailVC
        super.init(nibName: String(describing: TripTipFeedbackVC.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                            self.tripDetailVC.viewModel.trip = trip
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
    
}

extension TripTipFeedbackVC: UITableViewDataSource {
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
}


extension TripTipFeedbackVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedChoice = indexPath.row
        tableView.cellForRow(at: indexPath as IndexPath)?.tintColor = config.secondaryColor
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.selectedChoice = 0
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

fileprivate extension TripTipFeedbackVC {
    func configureContent() {
        let contentAttribute = [NSAttributedString.Key.foregroundColor: UIColor.dkGrayText]
        let contentAttributedText = NSAttributedString(string: viewModel.content, attributes: contentAttribute)
        contentLabel.attributedText = contentAttributedText
    }
    
    func configureComment() {
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.dkGrayText.cgColor
        commentTextView.layer.cornerRadius = 5
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
