//
//  ChallengeParticipationVC.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 19/05/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

class ChallengeParticipationVC: DKUIViewController {
    @IBOutlet private weak var stackView: UIStackView?
    @IBOutlet private weak var titleAttributedLabel: UILabel?
    @IBOutlet private weak var descriptionAttributedLabel: UILabel?
    @IBOutlet private weak var conditionsAttributedLabel: UILabel?
    @IBOutlet private weak var conditionsLabelView: UIView?
    @IBOutlet private weak var rulesButton: UIButton?
    @IBOutlet private weak var rulesView: UIView?
    @IBOutlet private weak var joinButton: UIButton?
    @IBOutlet private weak var participationAttributedLabel: UILabel?
    @IBOutlet private weak var countDownAttributedLabel: UILabel?
    @IBOutlet private weak var footerView: UIView?
    @IBOutlet private weak var footerHeightConstraint: NSLayoutConstraint?

    private let viewModel: ChallengeParticipationViewModel?

    public init(viewModel: ChallengeParticipationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChallengeParticipationVC.self), bundle: Bundle.challengeUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.getTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewElements()
    }

    func setupViewElements() {
        titleAttributedLabel?.attributedText = viewModel?.getTitleAttributedString()
        descriptionAttributedLabel?.attributedText = viewModel?.getChallengeRulesAttributedString()
        if let conditionsAttributedText = viewModel?.getChallengeConditionsAttributedString() {
            conditionsAttributedLabel?.attributedText = conditionsAttributedText
        } else {
            conditionsLabelView?.isHidden = true
        }
        setupRulesButton()
        setupJoinButton()
        setupFooter()
        stackView?.setNeedsLayout()
    }

    func setupRulesButton() {
        rulesButton?.setTitle("dk_challenge_consult_rule_button".dkChallengeLocalized(), for: .normal)
        rulesButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
        if viewModel?.haveLongRules() == false {
            rulesView?.isHidden = true
        }
    }

    func setupJoinButton() {
        if viewModel?.getDisplayState() == .join {
            joinButton?.configure(style: .full)
            joinButton?.setTitle("dk_challenge_participate_button".dkChallengeLocalized(), for: .normal)
            joinButton?.titleLabel?.font = DKUIFonts.primary.fonts(size: 20).with(.traitBold)
        }
    }

    func setupFooter() {
        if viewModel?.getDisplayState() == .join {
            participationAttributedLabel?.isHidden = true
            participationAttributedLabel?.isHidden = true
            joinButton?.isHidden = false
            footerHeightConstraint?.constant = 50
            footerView?.backgroundColor = .white
        } else {
            participationAttributedLabel?.isHidden = false
            participationAttributedLabel?.isHidden = false
            joinButton?.isHidden = true
            footerView?.backgroundColor = DKUIColors.primaryColor.color
            participationAttributedLabel?.attributedText = viewModel?.getSubscriptionAttributedString()
            if viewModel?.getDisplayState() == .countDown {
                countDownAttributedLabel?.attributedText = viewModel?.getCountDownAttributedString()
                footerHeightConstraint?.constant = 80
            } else {
                footerHeightConstraint?.constant = 50
            }
        }
    }

    @IBAction func goToRulesVC() {
        if let rulesViewModel: ChallengeRulesViewModel = viewModel?.getRulesViewModel() {
            let rulesVC: ChallengeRulesVC = ChallengeRulesVC(viewModel: rulesViewModel)
            self.navigationController?.pushViewController(rulesVC, animated: true)
        }
    }
    @IBAction func joinButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        if viewModel.haveLongRules() {
            goToRulesVC()
        } else {
            self.showLoader()
            viewModel.joinChallenge { [weak self] status in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    if status == .joined {
                        self?.setupViewElements()
                    } else if status == .failedToJoin {
                        self?.showAlertMessage(title: nil, message: "dk_challenge_failed_to_join".dkChallengeLocalized(), back: false, cancel: false)
                    }
                }
            }
        }
    }
}
