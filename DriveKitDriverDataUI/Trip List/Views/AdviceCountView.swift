//
//  AdviceCountView.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 29/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit

final class AdviceCountView: UIView, Nibable  {

    @IBOutlet weak var adviceCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAdviceCount(count: String){
        adviceCountLabel.textColor = .white
        adviceCountLabel.text = count
    }

}
