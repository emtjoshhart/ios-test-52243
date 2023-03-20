//
//  DoubleGridCollectionLayout.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class DoubleGridCollectionLayout: UICollectionViewCompositionalLayout {
    static let width = (UIScreen.main.bounds.width/2) - 20
    static let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))

    init() {
        let section = Self.section
        super.init(section: section)
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    static var groupSize: NSCollectionLayoutSize {
        NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(274))
    }

    static var group: NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(10.0)
        return group
    }

    static var section: NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 5
        section.contentInsets.bottom = 10
        section.interGroupSpacing = 10
        return section
    }
}
