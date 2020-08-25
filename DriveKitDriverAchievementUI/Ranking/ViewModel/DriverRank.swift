//
//  DriverRank.swift
//  DriveKitDriverAchievementUI
//
//  Created by David Bauduin on 07/07/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation

protocol AnyDriverRank {
    var nbDrivers: Int { get }
    var position: Int { get }
    var positionString: String { get }
    var positionImageName: String? { get }
    var rankString: String { get }
    var name: String { get }
    var distance: Double { get }
    var distanceString: String { get }
    var score: Double { get }
    var scoreString: String { get }
    var totalScoreString: String { get }
}


struct DriverRank : AnyDriverRank {
    let nbDrivers: Int
    let position: Int
    let positionString: String
    let positionImageName: String?
    let rankString: String
    let name: String
    let distance: Double
    let distanceString: String
    let score: Double
    let scoreString: String
    let totalScoreString: String
}

struct CurrentDriverRank : AnyDriverRank {
    let driverRank: DriverRank
    let progressionImageName: String?

    var nbDrivers: Int { get { self.driverRank.nbDrivers } }
    var position: Int { get { self.driverRank.position } }
    var positionString: String { get { self.driverRank.positionString } }
    var positionImageName: String? { get { self.driverRank.positionImageName } }
    var rankString: String { get { self.driverRank.rankString } }
    var name: String { get { self.driverRank.name } }
    var distance: Double { get { self.driverRank.distance } }
    var distanceString: String { get { self.driverRank.distanceString } }
    var score: Double { get { self.driverRank.score } }
    var scoreString: String { get { self.driverRank.scoreString } }
    var totalScoreString: String { get { self.driverRank.totalScoreString } }
}
