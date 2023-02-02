//
//  UICollectionViewCellExtensions.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
