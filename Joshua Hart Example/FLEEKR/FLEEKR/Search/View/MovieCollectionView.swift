//
//  MovieCollectionView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class MovieCollectionView: UICollectionView {

    init(frame: CGRect) {
        let layout = DoubleGridCollectionLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    private func setup() {
        self.allowsMultipleSelection = false
        self.isScrollEnabled = true
        self.backgroundColor = .clear
        self.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
    }
}
