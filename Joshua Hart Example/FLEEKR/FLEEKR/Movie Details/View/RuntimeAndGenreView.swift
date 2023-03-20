//
//  RuntimeAndGenreView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class RuntimeAndGenreView: UIView {

    // MARK: - INITIALERS:

    init(runtime: String, genre: String) {
        super.init(frame: .zero)
        self.setupUI()
        self.runtimeLabel.text = runtime.uppercased()
        self.genreLabel.text = genre.uppercased().replacingOccurrences(of: ", ", with: "\n")
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - SETUP UI:

    private func setupUI() {
        addSubview(runtimeLabel, constraints: [.leading(3), .top(5), .trailing(-3)])
        addSubview(runtimeDividerView, constraints: [.leading(25), .trailing(-25)])
        runtimeDividerView.constrainVertically(to: runtimeLabel, constraints: [.topToBottom(5)])
        addSubview(genreLabel, constraints: [.leading(3), .trailing(-3), .bottom(-5)])
        genreLabel.constrainVertically(to: runtimeDividerView, constraints: [.topToBottom(5)])
    }

    // MARK: - UI COMPONENTS:

    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 11)
        label.textAlignment = .center
        label.textColor = .babyBlue
        label.height(13)
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .babyBlue
        return label
    }()

    private lazy var runtimeDividerView: UIView = {
        let divider = UIView()
        divider.height(1)
        divider.backgroundColor = .slateBlue
        return divider
    }()
}
