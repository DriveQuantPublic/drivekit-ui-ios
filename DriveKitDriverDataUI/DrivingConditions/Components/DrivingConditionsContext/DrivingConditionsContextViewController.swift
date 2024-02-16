//
//  DrivingConditionsContextViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 05/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import UIKit

class DrivingConditionsContextViewController: DKUIViewController, DKUIPageViewModel {
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
        self.cardView.applyCardStyle()
        let horizontalMargin: CGFloat = 12
        let topMargin: CGFloat = 1
        let bottomMargin: CGFloat = 2
        self.view.embedSubview(self.cardView, margins: UIEdgeInsets(top: topMargin, left: horizontalMargin, bottom: bottomMargin, right: horizontalMargin))
    }
}
