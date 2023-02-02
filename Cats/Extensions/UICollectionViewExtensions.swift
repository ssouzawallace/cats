//
//  UICollectionViewExtensions.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type){
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<CellClass: UICollectionViewCell>(ofType cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass? {
        dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier,
                            for: indexPath) as? CellClass
    }
}
