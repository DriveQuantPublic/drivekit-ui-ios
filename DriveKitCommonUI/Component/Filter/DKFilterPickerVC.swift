// swiftlint:disable no_magic_numbers
//
//  DKFilterPickerVC.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 30/09/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

final public class DKFilterPickerVC: DKUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: DKFilterViewModel
    
    public init(viewModel: DKFilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DKFilterPickerVC.self), bundle: Bundle.driveKitCommonUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "DKFilterTableViewCell", bundle: Bundle.driveKitCommonUIBundle), forCellReuseIdentifier: "DKFilterTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.cancelButton.configure(title: DKCommonLocalizable.cancel.text(), style: .full)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DKFilterPickerVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = DriveKitUI.shared.colors.backgroundViewColor()
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.itemSelected(position: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}

extension DKFilterPickerVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DKFilterTableViewCell")
        if let filterCell = cell as? DKFilterTableViewCell {
            filterCell.configure(viewModel: self.viewModel, position: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
