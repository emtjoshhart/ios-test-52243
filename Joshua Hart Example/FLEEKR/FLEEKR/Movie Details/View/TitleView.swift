//
//  TitleView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class TitleView: UIVisualEffectView {
    let title: String

    // MARK: - INITIALERS:

    init(title: String) {
        self.title = title
        let blurEffect = UIBlurEffect(style: .dark)
        super.init(effect: blurEffect)
        self.setupUI()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }

    // MARK: - SETUP UI:

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        contentView.addSubview(movieTitleLabel, constraintSet: .tlbt(margin: 30))
    }

    // MARK: - UI COMPONENTS:

    private lazy var titleContainer: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = .clear
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        blurEffectView.contentView.addSubview(movieTitleLabel, constraintSet: .tlbt(margin: 30))
        return blurEffectView
    }()

    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .babyBlue
        label.text = title.uppercased().replacingOccurrences(of: ":", with: "\n")
        return label
    }()
}
