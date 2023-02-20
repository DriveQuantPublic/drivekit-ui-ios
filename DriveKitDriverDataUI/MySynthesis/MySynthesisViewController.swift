//
//  MySynthesisViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 16/02/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class MySynthesisViewController: DKUIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scoreSelectorContainer: UIView!
    @IBOutlet private weak var periodSelectorContainer: UIView!
    @IBOutlet private weak var dateSelectorContainer: UIView!
    @IBOutlet private weak var scoreViewContainer: UIView!
    @IBOutlet private weak var communityViewContainer: UIView!
    @IBOutlet weak var showDetailButton: UIButton!
    
    private let viewModel: MySynthesisViewModel
    
    init(viewModel: MySynthesisViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MySynthesisViewController.self), bundle: .driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
