//
//  CatsCollectionViewLayout.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import UIKit

class CatsCollectionViewLayout: UICollectionViewCompositionalLayout {
    init(columns: UInt = 3) {
        let fraction = 1.0/CGFloat(columns)
        let contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                    leading: 5,
                                                    bottom: 5,
                                                    trailing: 5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contentInsets
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
