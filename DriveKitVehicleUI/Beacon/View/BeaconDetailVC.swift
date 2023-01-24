// swiftlint:disable all
//
//  BeaconDetailVC.swift
//  DriveKitVehicleUI
//
//  Created by Jérémy Bayle on 17/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import MessageUI

class BeaconDetailVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: BeaconDetailViewModel
    
    init(viewModel: BeaconDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BeaconDetailVC", bundle: .vehicleUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "BeaconDetailTableViewCell", bundle: Bundle.vehicleUIBundle), forCellReuseIdentifier: "BeaconDetailTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = "dk_beacon_diagnostic_title".dkVehicleLocalized()
        self.configureMailButton()
    }
    
    private func configureMailButton() {
        if DriveKitVehicleUI.shared.beaconDiagnosticEmail != nil {
            let image = DKImages.mail.image?.resizeImage(25, opaque: false)
            let mailButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sendEmail))
            mailButton.tintColor = DKUIColors.navBarElementColor.color
            self.navigationItem.rightBarButtonItem = mailButton
        }
    }
    
    @objc private func sendEmail() {
        if let urlString = DriveKitVehicleUI.shared.beaconDiagnosticSupportLink {
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else {
            if MFMailComposeViewController.canSendMail(), let mail = DriveKitVehicleUI.shared.beaconDiagnosticEmail {
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients(mail.getRecipients())
                mailComposerVC.setBccRecipients(mail.getBccRecipients())
                mailComposerVC.setSubject(mail.getSubject())
                if mail.overrideMailBodyContent() {
                    mailComposerVC.setMessageBody("\(mail.getMailBody())", isHTML: false)
                } else {
                    mailComposerVC.setMessageBody("\(mail.getMailBody())\n\n\(viewModel.mailContent())", isHTML: false)
                }
                present(mailComposerVC, animated: true)
            }
        }
    }
}

extension BeaconDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BeaconDetailTableViewCell", for: indexPath) as! BeaconDetailTableViewCell
        cell.configure(pos: indexPath.row, viewModel: self.viewModel)
        return cell
    }
}

extension BeaconDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension BeaconDetailVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result != .failed {
            controller.dismiss(animated: true)
        }
    }
}
