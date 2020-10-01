//
//  DKFilterPickerVC.swift
//  DriveKitCommonUI
//
//  Created by Jérémy Bayle on 30/09/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

protocol FilterPickerDelegate : AnyObject {
    func didSelectFilterItem(item : DKFilterItem)
}

class DKFilterPickerVC: DKUIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private weak var viewModel : DKFilterViewModel?
    weak var delegate : FilterPickerDelegate?
    
    public init(viewModel: DKFilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DKFilterPickerVC.self), bundle: Bundle.driveKitCommonUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "DKFilterTableViewCell", bundle: Bundle.driveKitCommonUIBundle), forCellReuseIdentifier: "DKFilterTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DKFilterPickerVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 8))
        headerView.backgroundColor = DriveKitUI.shared.colors.backgroundViewColor()
        return headerView
    }
}

extension DKFilterPickerVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DKFilterTableViewCell")
        if let filterCell = cell as? DKFilterTableViewCell, let viewModel = self.viewModel {
            filterCell.configure(viewModel: viewModel, position: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
