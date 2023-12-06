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
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let cell = cell as? T else {
            fatalError("Invalid cell type. Expected: \(type(of: T())), found: \(type(of: cell))")
        }
        return cell
    }

    public func dequeue<T: UITableViewCell>(withIdentifier identifier: String) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: identifier)
        guard let cell = cell as? T else {
            fatalError("Invalid cell type. Expected: \(type(of: T())), found: \(type(of: cell))")
        }
        return cell
    }
 
    public func dequeueHeaderFooterView<T: UIView>(withIdentifier identifier: String) -> T {
        let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        guard let headerFooter = headerFooter as? T else {
            fatalError("Invalid cell type. Expected: \(type(of: T())), found: \(type(of: headerFooter))")
        }
        return headerFooter
    }

}

extension UICollectionView {
    public func dequeue<T: UICollectionViewCell>(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = cell as? T else {
            fatalError("Invalid cell type. Expected: \(type(of: T())), found: \(type(of: cell))")
        }
        return cell
    }
}
