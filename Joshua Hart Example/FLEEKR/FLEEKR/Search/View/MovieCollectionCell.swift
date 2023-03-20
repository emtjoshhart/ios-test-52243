//
//  MovieCollectionCell.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit
import Kingfisher

class MovieCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentContainerView, constraintSet: .tlbt(margin: 1))
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    func setup(title: String, imageUrlString: String) {
        let url = URL(string: imageUrlString)
        movieImageView.kf.setImage(
            with: url,
            placeholder: #imageLiteral(resourceName: "no_movie_image"),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ],
            progressBlock: { _, _ in
                // Progress updated
            },
            completionHandler: { _ in
                // Done
            }
        )
        movieTitleLabel.text = title
    }

    /// Shows or removes the loading indicator on the main thread.
    /// - Parameter show: (Bool) Whether or not to show or remove the loading indicator.
    func showLoadingIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                guard self.loadingIndicator.superview == nil else { return }
                self.loadingIndicator.setAnimating(true)
                self.contentView.addSubview(self.loadingIndicator, constraintSet: .tlbt(margin: 0))
            } else {
                guard self.loadingIndicator.superview != nil else { return }
                self.loadingIndicator.setAnimating(false)
                self.loadingIndicator.removeFromSuperview()
            }
        }
    }

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .pastelBlue
        label.height(14)
        return label
    }()

    private lazy var contentContainerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        container.backgroundColor = .clear
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = .init(width: 0, height: 3)
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 0.5
        container.addSubview(movieImageView, constraints: [.top(5), .leading(5), .trailing(-5)])
        container.addSubview(movieTitleLabel, constraints: [.leading(8), .bottom(-5), .trailing(-8)])
        movieTitleLabel.constrainVertically(to: movieImageView, constraints: [.topToBottom(8)])
        return container
    }()

    private lazy var loadingIndicator: LoadingIndicatorView = { LoadingIndicatorView() }()
}
