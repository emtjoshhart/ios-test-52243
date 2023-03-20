//
//  GradientView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit

class GradientView: UIView {

    /// Cast the view's CALayer to CAGradientLayer.
    private lazy var gradientLayer: CAGradientLayer? = {
        self.layer as? CAGradientLayer
    }()

    /// The top color of the gradient view.
    var topColor: UIColor = .hex(0xF574FF) { didSet { setNeedsLayout() }}
    /// The bottom color of the gradient view.
    var bottomColor: UIColor = .hex(0xE8FFA2) { didSet { setNeedsLayout() }}
    /// Where the top color should start on the X axis.
    var startPointX: CGFloat = 0 { didSet { setNeedsLayout() }}
    /// Where the top color should start on the Y axis.
    var startPointY: CGFloat = 0 { didSet { setNeedsLayout() }}
    /// Where the bottom color should start on the X axis.
    var endPointX: CGFloat = 0 { didSet { setNeedsLayout() }}
    /// Where the bottom color should start of the Y axis.
    var endPointY: CGFloat = 0.6 { didSet { setNeedsLayout() }}

    // MARK: - INITIALIZERS:

    init(topColor: UIColor, bottomColor: UIColor) {
        super.init(frame: .zero)
        self.topColor = topColor
        self.bottomColor = bottomColor
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    override class var layerClass: AnyClass { CAGradientLayer.self }

    override func layoutSubviews() {
        self.gradientLayer?.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer?.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer?.endPoint = CGPoint(x: endPointX, y: endPointY)
    }

    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey: "animateGradient")
    }
}
