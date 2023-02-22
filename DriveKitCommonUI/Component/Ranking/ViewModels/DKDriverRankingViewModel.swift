// swiftlint:disable all
//
//  DKDriverRankingViewModel.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 22/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import Foundation

public struct DKDriverRankingViewModel {
    weak private(set) var ranking: DKDriverRanking?

    public init(ranking: DKDriverRanking) {
        self.ranking = ranking
    }
}
