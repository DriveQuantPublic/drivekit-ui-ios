//
//  MySynthesisCommunityCardViewModel.swift
//  DriveKitDriverDataUI
//
//  Created by Frédéric Ruaudel on 06/03/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import DriveKitCommonUI
import Foundation

public class MySynthesisCommunityCardViewModel {
    var communityCardViewModelDidUpdate: (() -> Void)?
    
    public init() {}
    
    public var title: String {
        return "TBD"
    }
    
    public var titleColor: DKUIColors {
        return .primaryColor
    }
        
    public func configure(
    ) {
    }
    
    // MARK: - Private Helpers
    
}
