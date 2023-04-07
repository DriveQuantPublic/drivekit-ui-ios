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
    
    init(context: DKContextKind) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.embedSubview(self.contextView(for: context))
        self.view.backgroundColor = .white
    }

    private func contextView(for context: DKContextKind) -> UIView {
        #warning("Setup each context kind view")
        let label = UILabel()
        label.text = "Context \(context)"
        return label
    }
}
