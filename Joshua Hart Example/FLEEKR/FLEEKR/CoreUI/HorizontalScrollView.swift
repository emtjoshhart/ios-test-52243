//
//  HorizontalScrollView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import UIKit

open class HorizontalScrollView: UIScrollView {
    internal var arrangedViews: [UIView] = []
    private var arrangedViewContraints: [NSLayoutConstraint] = []

    var interItemSpacing: CGFloat = 8.0 {
        didSet { setNeedsUpdateConstraints() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        delaysContentTouches = false
        contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

    func addArrangedViews(_ views: [UIView]) {
        DispatchQueue.main.async {
            views.forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.arrangedViews.append($0)
                self.addSubview($0)
            }
            self.setNeedsUpdateConstraints()
        }
    }

    func removeView(index: Int, completion: ((Bool) -> Void)? = nil) {
        guard let view = self.arrangedViews[safe: index] else { return }
        view.alpha = 1.0
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 0
        }, completion: { [weak self] _ in
            DispatchQueue.main.async {
                self?.arrangedViews.remove(at: index)
                view.removeFromSuperview()
                self?.updateConstraints()
                completion?(true)
            }
        })
    }

    func removeAllAssetLibraryViews() {
        guard !arrangedViews.isEmpty else { return }

        for subview in subviews {
            subview.removeFromSuperview()
        }

        updateConstraints()
    }

    func removeAllArrangedViews(shouldLeaveAttachmentButton: Bool = true) {
        guard let first = arrangedViews.first else { return }
        arrangedViews = shouldLeaveAttachmentButton ? [first] : []
        for subview in subviews {
            if shouldLeaveAttachmentButton, subview == first { continue }
            subview.removeFromSuperview()
        }

        updateConstraints()
    }

    override open func updateConstraints() {
        super.updateConstraints()
        removeConstraintsForArrangedViews()
        addConstraintsForArrangedViews()
    }

    private func removeConstraintsForArrangedViews() {
        arrangedViewContraints.forEach { $0.isActive = false }
        arrangedViewContraints.removeAll()
    }

    private func addConstraintsForArrangedViews() {
        for (index, view) in arrangedViews.enumerated() {
            switch index {
            case 0:
                arrangedViewContraints.append(view.constrain(.leading(0)))
                arrangedViewContraints.append(view.constrain(.top(0)))

            case arrangedViews.count-1:
                arrangedViewContraints.append(view.constrain(.trailing(0)))
                arrangedViewContraints.append(view.constrain(.top(0)))
                fallthrough
            default:
                let constraints = view
                    .constrainHorizontally(to: arrangedViews[index - 1],
                                           constraints: [.leadingToTrailing(interItemSpacing)])
                arrangedViewContraints.append(contentsOf: constraints)
            }
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
