// swiftlint:disable no_magic_numbers
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
    @IBOutlet private weak var joinButtonContainer: UIView?
    @IBOutlet private weak var joinButton: UIButton?
    @IBOutlet private weak var participationAttributedLabel: UILabel?
    @IBOutlet private weak var countDownAttributedLabel: UILabel?
    @IBOutlet private weak var footerView: UIView?
    @IBOutlet private weak var footerHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var conditionsHeaderView: UIView?
    @IBOutlet private weak var conditionsHeaderAttributedLabel: UILabel?
    @IBOutlet private weak var conditionsProgressTableView: UITableView?
    @IBOutlet private weak var progressTableViewConstraint: NSLayoutConstraint?
    @IBOutlet private weak var separator1: UIView?
    @IBOutlet private weak var separator2: UIView?
    @IBOutlet private weak var separator3: UIView?
    private weak var parentView: UIViewController?

    private let viewModel: ChallengeParticipationViewModel?
    private var timer: Timer?

    public init(viewModel: ChallengeParticipationViewModel, parentView: UIViewController? = nil) {
        self.viewModel = viewModel
        self.parentView = parentView
        super.init(nibName: String(describing: ChallengeParticipationVC.self), bundle: Bundle.challengeUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DKDefaultColors.driveKitBackgroundColor
        title = viewModel?.getTitle()
        if parentView == nil {
            DriveKitUI.shared.trackScreen(tagKey: "dk_tag_challenge_join", viewController: self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewElements()
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        super.viewDidDisappear(animated)
    }

    func setupViewElements() {
        setupTitleDescriptionAndConditions()
        setupRulesButton()
        setupProgressTableAndHeader()
        setupJoinButton()
        setupFooter()
        setupCountDownTimer()
        conditionsProgressTableView?.register(ChallengeConditionProgressTableViewCell.nib, forCellReuseIdentifier: "ChallengeConditionProgressTableViewCellIdentifier")
        separator1?.backgroundColor = DKUIColors.neutralColor.color
        separator2?.backgroundColor = DKUIColors.neutralColor.color
        separator3?.backgroundColor = DKUIColors.neutralColor.color
    }

    func setupTitleDescriptionAndConditions() {
        titleAttributedLabel?.attributedText = viewModel?.getTitleAttributedString()
        descriptionAttributedLabel?.attributedText = viewModel?.getChallengeRulesAttributedString()
        if let conditionsAttributedText = viewModel?.getChallengeConditionsAttributedString() {
            conditionsAttributedLabel?.attributedText = conditionsAttributedText
        } else {
            conditionsLabelView?.isHidden = true
            if self.viewModel?.haveLongRules() == false {
                separator2?.isHidden = true
            }
        }
    }

    func setupCountDownTimer() {
        if viewModel?.getDisplayState() == .countDown, timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }

    func setupRulesButton() {
        rulesButton?.setTitle("dk_challenge_consult_rule_button".dkChallengeLocalized(), for: .normal)
        rulesButton?.setTitleColor(DKUIColors.secondaryColor.color, for: .normal)
        if viewModel?.haveLongRules() == false {
            rulesView?.isHidden = true
            separator3?.isHidden = true
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
        if viewModel?.getDisplayState() == .rulesTab {
            participationAttributedLabel?.isHidden = true
            countDownAttributedLabel?.isHidden = true
            joinButtonContainer?.isHidden = true
            footerHeightConstraint?.constant = 0
        } else if viewModel?.getDisplayState() == .join {
            participationAttributedLabel?.isHidden = true
            countDownAttributedLabel?.isHidden = true
            joinButtonContainer?.isHidden = false
            footerHeightConstraint?.constant = 50
            footerView?.backgroundColor = DKDefaultColors.driveKitBackgroundColor
        } else {
            participationAttributedLabel?.isHidden = false
            joinButtonContainer?.isHidden = true
            footerView?.backgroundColor = DKUIColors.primaryColor.color
            participationAttributedLabel?.attributedText = viewModel?.getSubscriptionAttributedString()
            if viewModel?.getDisplayState() == .countDown {
                countDownAttributedLabel?.isHidden = false
                updateCountDown()
                footerHeightConstraint?.constant = 80
            } else {
                countDownAttributedLabel?.isHidden = true
                footerHeightConstraint?.constant = 50
            }
        }
    }

    @objc private func updateCountDown() {
        countDownAttributedLabel?.attributedText = viewModel?.getCountDownAttributedString()
    }

    @IBAction func goToRulesVC() {
        if let rulesViewModel: ChallengeRulesViewModel = viewModel?.getRulesViewModel() {
            let rulesVC: ChallengeRulesVC = ChallengeRulesVC(viewModel: rulesViewModel)
            if let navigationController = self.navigationController {
                navigationController.pushViewController(rulesVC, animated: true)
            } else if let parentView: UINavigationController = self.parentView as? UINavigationController {
                parentView.pushViewController(rulesVC, animated: true)
            }
        }
    }

    func setupProgressTableAndHeader() {
        if viewModel?.getDisplayState() == .progress {
            conditionsHeaderView?.backgroundColor = DKUIColors.primaryColor.color
            conditionsHeaderAttributedLabel?.attributedText = viewModel?.getConditionsHeaderAttributedString()
            conditionsHeaderView?.isHidden = false
            conditionsProgressTableView?.isHidden = false
            progressTableViewConstraint?.constant = self.viewModel?.getConditionsProgressTableHeight() ?? 0
            conditionsProgressTableView?.reloadData()
        } else {
            conditionsHeaderView?.isHidden = true
            conditionsProgressTableView?.isHidden = true
            progressTableViewConstraint?.constant = 0
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

extension ChallengeParticipationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getConditionsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ChallengeConditionProgressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeConditionProgressTableViewCellIdentifier") 
            as? ChallengeConditionProgressTableViewCell {
            if let challengeProgressViewModel = self.viewModel?.getConditionViewModel(index: indexPath.row) {
                cell.configure(viewModel: challengeProgressViewModel)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
