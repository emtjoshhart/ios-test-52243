//
//  LanguageAndRatingView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class LanguageAndRatingView: UIView {

    // MARK: - INITIALERS:

    init(language: String, rated: String) {
        super.init(frame: .zero)
        self.setupUI()
        self.languageLabel.text = language.components(separatedBy: ",").first?.uppercased() ?? "Unknown"
        self.ratingLabel.text = rated.uppercased()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - SETUP UI:

    private func setupUI() {
        addSubview(languageLabel, constraints: [.leading(3), .top(5), .trailing(-3)])
        addSubview(languageDividerView, constraints: [.leading(25), .trailing(-25)])
        languageDividerView.constrainVertically(to: languageLabel, constraints: [.topToBottom(5)])
        addSubview(ratingLabel, constraints: [.leading(3), .trailing(-3), .bottom(-5)])
        ratingLabel.constrainVertically(to: languageDividerView, constraints: [.topToBottom(5)])
    }

    // MARK: - UI COMPONENTS:

    private lazy var languageDividerView: UIView = {
        let divider = UIView()
        divider.height(1)
        divider.backgroundColor = .slateBlue
        return divider
    }()

    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 11)
        label.textAlignment = .center
        label.textColor = .babyBlue
        label.height(13)
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 11)
        label.textAlignment = .center
        label.textColor = .babyBlue
        label.height(13)
        return label
    }()
}
