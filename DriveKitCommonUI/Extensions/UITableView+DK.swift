//
//  UITableView+DK.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 27/11/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

extension UITableView {
    public func dequeue<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Invalid cell type")
        }
        return cell
    }

    public func dequeue<T: UITableViewCell>(withIdentifier identifier: String) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Invalid cell type")
        }
        return cell
    }
}

extension UICollectionView {
    public func dequeue<T: UICollectionViewCell>(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Invalid cell type")
        }
        return cell
    }
}
