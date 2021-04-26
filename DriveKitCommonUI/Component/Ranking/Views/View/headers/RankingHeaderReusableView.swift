//
//  RankingHeaderReusableView.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 26/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

class RankingHeaderReusableView: UICollectionReusableView {

    @IBOutlet private weak var summaryContainer: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func embedSummaryView(summaryView: UIView) {
        if let summaryContainer = summaryContainer {
            for subview in summaryContainer.subviews {
                subview.removeFromSuperview()
            }
            summaryContainer.embedSubview(summaryView)
        }
    }
}
