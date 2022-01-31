//
//  UITableView.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public func register1<T: UITableViewCell>(cellClass: T.Type) {
        let cellId = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: cellId)
    }
    
    public func dequeue1<T: UITableViewCell>(cellClass: T.Type) -> T? {
        let cellId = String(describing: cellClass)
        return dequeueReusableCell(withIdentifier: cellId) as? T
    }
    
    public func dequeue1<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let cellId = String(describing: cellClass)
        guard let cell = dequeueReusableCell(withIdentifier: cellId,
                                             for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(cellId) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
}

