// swiftlint:disable no_magic_numbers
//
//  ChallengeListViewModel.swift
//  DriveKitChallengeUI
//
//  Created by Amine Gahbiche on 30/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import DriveKitChallengeModule
import DriveKitDBChallengeAccessModule
import DriveKitCommonUI
import DriveKitCoreModule
import UIKit

public protocol ChallengeListDelegate: AnyObject {
    func onChallengesAvailable()
    func challengesFetchStarted()
    func didReceiveErrorFromService()
    func showAlert(_ viewController: UIViewController)
    func showLoader()
    func hideLoader()
    func showViewController(_ viewController: UIViewController, animated: Bool)
}

public class ChallengeListViewModel {
    private var challenges: [DKChallenge] = []
    private(set) var activeChallenges: [ChallengeItemViewModel] = []
    private(set) var rankedChallenges: [ChallengeItemViewModel] = []
    private(set) var allChallenges: [ChallengeItemViewModel] = []
    public weak var delegate: ChallengeListDelegate?
    public private(set) var selectedTab: ChallengeListTab = .active
    let dateSelectorViewModel: DKDateSelectorViewModel
    var selectedYear: Int?

    init() {
        self.dateSelectorViewModel = DKDateSelectorViewModel()
        self.dateSelectorViewModel.delegate = self
        DriveKitChallenge.shared.getChallenges(type: .cache) { [weak self] _, challenges in
            if let self = self {
                self.challenges = challenges.filterDeprecated().sortByDate()
                self.updateChallengeArrays()
            }
        }
    }

    func fetchChallenges(fromServer: Bool = true) {
        delegate?.challengesFetchStarted()
        let syncType: SynchronizationType = fromServer ? .defaultSync : .cache
        DriveKitChallenge.shared.getChallenges(type: syncType) { [weak self] _, challenges in
            DispatchQueue.main.async {
                if let self = self {
                    self.challenges = challenges.filterDeprecated().sortByDate()
                    self.updateChallengeArrays(for: self.selectedYear)
                    self.delegate?.onChallengesAvailable()
                }
            }
        }
    }

    func updateSelectedTab(challengeTab: ChallengeListTab) {
        selectedYear = nil
        selectedTab = challengeTab
        self.dateSelectorViewModel.configure(
            dates: self.getDates(),
            period: .year
        )
        updateChallengeArrays()
        self.delegate?.onChallengesAvailable()
    }

    func expectedCellHeight(challenge: ChallengeItemViewModel, viewWdth: CGFloat) -> CGFloat {
        let width = viewWdth - 124
        let attributedText: NSAttributedString = NSAttributedString(string: challenge.name, attributes: [.font: DKStyles.headLine1.style.applyTo(font: .primary)])
        let expectedRect = attributedText.boundingRect(with: CGSize(width: width, height: 600), options: .usesLineFragmentOrigin, context: nil)
        return max(124.0, expectedRect.height + 83)
    }

    func challengeViewModelSelected(challengeViewModel: ChallengeItemViewModel) {
        if challengeViewModel.finishedAndNotFilled {
            let alertTitle = Bundle.main.appName ?? ""
            let alert = UIAlertController(title: alertTitle, message: "dk_challenge_not_a_participant".dkChallengeLocalized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .cancel, handler: nil))
            self.delegate?.showAlert(alert)
        } else {
            self.openChallenge(withItinId: challengeViewModel.identifier)
        }
    }

    private func openChallenge(withItinId itinId: String) {
        self.delegate?.showLoader()
        DriveKitChallengeUI.shared.getChallengeViewController(challengeId: itinId) { [weak self] viewController in
            DispatchQueue.main.async {
                self?.delegate?.hideLoader()
                if let vc = viewController {
                    self?.delegate?.showViewController(vc, animated: true)
                }
            }
        }
    }

    private func updateChallengeArrays(for year: Int? = nil) {
        let lastYear = DriveKitUI.calendar.component(.year, from: self.challenges.filterBy(tab: .all).first?.endDate ?? Date())
        self.allChallenges = self.challenges.allChallenges(year: year ?? lastYear).map({ ChallengeItemViewModel(challenge: $0) })

        let lastYearForActives = DriveKitUI.calendar.component(.year, from: self.challenges.filterBy(tab: .active).first?.endDate ?? Date())
        self.activeChallenges = self.challenges.activeChallenges(year: year ?? lastYearForActives).map({ ChallengeItemViewModel(challenge: $0) })
        
        let lastYearForRanked = DriveKitUI.calendar.component(.year, from: self.challenges.filterBy(tab: .ranked).first?.endDate ?? Date())
        self.rankedChallenges = self.challenges.rankedChallenges(year: year ?? lastYearForRanked).map({ ChallengeItemViewModel(challenge: $0) })
        
        let allDates = self.getDates()
        let selectedIndex = allDates.selectedIndex(for: DriveKitUI.calendar.date(
            from: DateComponents(year: year, month: 1, day: 1)
        ))
        self.dateSelectorViewModel.configure(dates: allDates, period: .year, selectedIndex: selectedIndex)
    }

    private func getDates() -> [Date] {
        var dates = Set<Date>()
        let challengesArray: [DKChallenge] = self.challenges.filterBy(tab: selectedTab)
        for challenge in challengesArray {
            if let startYearDate = challenge.startDate.beginning(relativeTo: .year) {
                dates.insert(startYearDate)
            }
            if let endYearDate = challenge.endDate.beginning(relativeTo: .year) {
                dates.insert(endYearDate)
            }
        }
        if dates.isEmpty, let thisYearDate = Date().beginning(relativeTo: .year) {
            dates.insert(thisYearDate)
        }
        return dates.sorted()
    }

    func noChallengeMessage(for tab: ChallengeListTab) -> String {
        switch tab {
            case .active:
                return "dk_challenge_no_active_challenge".dkChallengeLocalized()
            case .ranked:
                let year = selectedYear ?? DriveKitUI.calendar.component(.year, from: Date())
                let yearChallenges = challenges.filterBy(year: year)
                if yearChallenges.isEmpty {
                    return "dk_challenge_no_ranked_challenge_empty_list".dkChallengeLocalized()
                } else if yearChallenges.filter({ $0.isRegistered }).isEmpty {
                    return "dk_challenge_no_ranked_challenge_not_registered_yet".dkChallengeLocalized()
                } else if yearChallenges.filter({ $0.conditionsFilled }).isEmpty {
                    return "dk_challenge_no_ranked_challenge_not_ranked_yet".dkChallengeLocalized()
                } else {
                    return "dk_challenge_no_ranked_challenge_empty_list".dkChallengeLocalized()
                }
            case .all:
                return "dk_challenge_no_all_challenge".dkChallengeLocalized()
        }
    }
}

extension ChallengeListViewModel: DKDateSelectorDelegate {
    public func dateSelectorDidSelectDate(_ date: Date) {
        let year = DriveKitUI.calendar.component(.year, from: date)
        self.selectedYear = year
        self.updateChallengeArrays(for: year)
        self.delegate?.onChallengesAvailable()
    }
}
