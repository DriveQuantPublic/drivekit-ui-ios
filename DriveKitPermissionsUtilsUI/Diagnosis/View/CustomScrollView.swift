//
//  CustomScrollView.swift
//  DriveKitPermissionsUtilsUI
//
//  Created by David Bauduin on 21/04/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

// Custom ScrollView to allow scrolling when a button is pressed, like in a CollectionView.
class CustomScrollView : UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        } else {
            return super.touchesShouldCancel(in: view)
        }
    }

}
