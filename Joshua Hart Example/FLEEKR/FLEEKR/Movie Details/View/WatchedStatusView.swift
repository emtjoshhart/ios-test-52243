//
//  WatchedStatusView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class WatchedStatusView: UIVisualEffectView {
    private let addedText = "Added to watched list!"
    private let removedText = "Removed from watched list!"
    private let addedImage = UIImage(systemName: "text.badge.plus")
    private let removedImage = UIImage(systemName: "text.badge.minus")

    // MARK: - INITIALERS:

    init() {
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        self.setupUI()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - EXPOSED FUNCTIONS:

    /// Updates the label and image of the status view.
    /// - Parameter wasAdded: (Bool) If the movie was added or removed from core data.
    func update(wasAdded: Bool) {
        DispatchQueue.main.async {
            self.watchedLabel.text = wasAdded ? self.addedText : self.removedText
            self.watchedImageView.image = wasAdded ? self.addedImage : self.removedImage
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        contentView.addSubview(watchedLabel, constraints: [.leading(40), .centerX(0), .centerY(50)])
        contentView.addSubview(watchedImageView, constraints: [.centerX(0)])
        watchedLabel.constrainVertically(to: watchedImageView, constraints: [.topToBottom(20)])
    }

    // MARK: - UI ELEMENTS:

    private lazy var watchedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var watchedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.width(100)
        imageView.height(100)
        imageView.tintColor = .lightGray
        return imageView
    }()
}
