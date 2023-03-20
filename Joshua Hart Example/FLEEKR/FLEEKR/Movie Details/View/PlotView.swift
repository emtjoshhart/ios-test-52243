//
//  PlotView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class PlotView: UIView {
    let plotString: String

    // MARK: - INITIALERS:

    init(summary: String) {
        self.plotString = summary
        super.init(frame: .zero)
        self.setupUI()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - SETUP UI:

    private func setupUI() {
        addSubview(plotSummaryLabel, constraints: [.leading(20), .top(0), .bottom(0), .trailing(0)])

        addSubview(plotLabel, constraints: [ .width(56), .height(30)])
        plotLabel.constrainHorizontally(to: plotSummaryLabel,
                                        constraints: [.centerY(0), .trailingToLeading(0)])
    }

    // MARK: - UI COMPONENTS:

    private lazy var plotLabel: UILabel = {
        let label = UILabel()
        label.text = "PLOT"
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 24)
        label.textColor = .slateBlue
        label.transform = CGAffineTransform(rotationAngle: -.pi/2)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var plotSummaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        if self.plotString.isEmpty ||
            self.plotString == "N/A" {
            label.font = UIFont(name: "Futura-Bold", size: 24)
            label.textColor = .slateBlue
            label.text = "SUMMARY UNAVAILABLE"
            label.textAlignment = .center
        } else {
            label.font = UIFont(name: "Futura", size: 16)
            label.textColor = .pastelBlue
            label.text = plotString
            label.textAlignment = .left
        }
        let height = label.heightAnchor.constraint(greaterThanOrEqualToConstant: 164)
        height.priority = .required
        height.isActive = true
        return label
    }()
}
