//
//  DrivingConditionsContextViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DrivingConditionsContextViewController: DKUIViewController, PageViewModeled {
    typealias PageId = DKContextKind
    typealias ViewModel = DKContextCard
    
    var pageId: DKContextKind
    private var cardView: DKContextCardView
    internal var viewModel: DKContextCard
    
    required init(pageId: DKContextKind, pageViewModel: DKContextCard) {
        self.pageId = pageId
        self.viewModel = pageViewModel
        self.cardView = DKContextCardView.createView()
        super.init(nibName: nil, bundle: nil)
        self.viewModel.contextCardDidUpdate { [weak self] in
            self?.cardView.refreshView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardView.configure(viewModel: self.viewModel)
        self.view.embedSubview(self.cardView)
        self.view.backgroundColor = .white
    }
}
