//
//  DrivingConditionsContextViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DrivingConditionsContextViewController: DKUIViewController {
    var context: DKContextKind
    private var cardView: DKContextCardView
    private var contextViewModel: DKContextCard
    
    init(context: DKContextKind, contextViewModel: DKContextCard) {
        self.context = context
        self.contextViewModel = contextViewModel
        self.cardView = DKContextCardView.createView()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardView.configure(viewModel: self.contextViewModel)
        self.view.embedSubview(self.cardView)
        self.view.backgroundColor = .white
    }
}
