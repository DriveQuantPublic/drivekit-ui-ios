//
//  ChallengeParticipationVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class ChallengeParticipationVC: UIViewController {
    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var titleAttributedLabel: UILabel?
    
    private let viewModel: ChalllengeParticipationViewModel?

    public init(viewModel: ChalllengeParticipationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeParticipationVC.self), bundle: Bundle.challengeUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.getTitle()
        titleAttributedLabel?.attributedText = viewModel?.getTitleAttributedSting()
    }
}
