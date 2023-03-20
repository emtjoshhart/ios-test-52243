//
//  LoadingIndicatorView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class LoadingIndicatorView: UIVisualEffectView {
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

    /// Starts and stops the animating of the loading indicator.
    /// - Parameter shouldStart: (Bool) If it should start animating or not.
    func setAnimating(_ shouldStart: Bool) {
        DispatchQueue.main.async {
            if shouldStart {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 20
        contentView.addSubview(backgroundView, constraintSet: .tlbt(margin: 0))
        contentView.addSubview(loadingIndicator, constraints: [.centerX(0), .centerY(0)])
    }

    // MARK: - UI ELEMENTS:

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.tintColor = .white
        activity.color = .white
        return activity
    }()
}
