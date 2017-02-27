//
//  ResuableProtocol.swift
//  Gank
//
//  Created by AHuaner on 2017/2/26.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

protocol ViewNameReusable: class { }

extension ViewNameReusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewNameReusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableCellFromNib<T: UITableViewCell>() -> T where T: ViewNameReusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            //return T(style: .default, reuseIdentifier: T.reuseIdentifier)
            return T.viewFromNib() as! T
        }
        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewNameReusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
