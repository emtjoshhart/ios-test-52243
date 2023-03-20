//
//  UIView+DF.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit

/// A single constraint.
enum Constraint {
    case constant(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  constant: CGFloat)

    case relative(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  relatedTo: NSLayoutConstraint.Attribute,
                  multiplier: CGFloat, constant: CGFloat)
}

// MARK: - CONSTRAINT:

extension Constraint {
    /// A leading constraint that attaches to the leading edge of the view.
    static let leading = relative(attribute: .leading, relation: .equal, relatedTo: .leading)
    /// A leading constraint that attaches to the leading margin of the view.
    static let leadingMargin = relative(attribute: .leading, relation: .equal, relatedTo: .leadingMargin)

    /// A trailing constraint that attaches to the trailing edge of the view.
    static let trailing = relative(attribute: .trailing, relation: .equal, relatedTo: .trailing)
    /// A trailing constraint that attaches to the trailing margin of the view.
    static let trailingMargin = relative(attribute: .trailing, relation: .equal, relatedTo: .trailingMargin)

    /// A top constraint that attaches to the top of the view.
    static let top = relative(attribute: .top, relation: .equal, relatedTo: .top)
    /// A top constraint that attaches to the top margin of the view.
    static let topMargin = relative(attribute: .top, relation: .equal, relatedTo: .topMargin)

    /// A bottom constraint that attaches to the bottom of the view.
    static let bottom = relative(attribute: .bottom, relation: .equal, relatedTo: .bottom)
    /// A bottom constraint that attaches to the bottom margin of the view.
    static let bottomMargin = relative(attribute: .bottom, relation: .equal, relatedTo: .bottomMargin)

    /// A horizontal constraint that attaches to the center X axis of the view.
    static let centerX = relative(attribute: .centerX, relation: .equal, relatedTo: .centerX)
    /// A vertical constraint that attaches to the center Y axis of the view.
    static let centerY = relative(attribute: .centerY, relation: .equal, relatedTo: .centerY)

    /// A width constraint that represents the size of the view horizontally.
    static let width = constant(attribute: .width, relation: .equal)
    /// A height constraint that represents the size of the view vertically.
    static let height = constant(attribute: .height, relation: .equal)

    /// Represents a constant constraint, but most importantly allows the passing of the constant to other properties.
    /// - Parameter attribute: (NSLayoutConstraint.Attribute) The layout attribute.
    /// - Parameter relation: (NSLayoutConstraint.Relation) The equality relation.
    private static func constant(attribute: NSLayoutConstraint.Attribute,
                                 relation: NSLayoutConstraint.Relation) -> (CGFloat) -> Constraint {
        { .constant(attribute: attribute, relation: relation, constant: $0) }
    }

    private static func relative(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        relatedTo: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1) -> (CGFloat) -> Constraint {{
            .relative(attribute: attribute, relation: relation,
                      relatedTo: relatedTo, multiplier: multiplier, constant: $0)
        }
        }
}

// MARK: - HORIZONATAL CONSTRAINTS:

enum HorizontalConstraint {
    case horizontal(attribute: NSLayoutConstraint.Attribute,
                    relation: NSLayoutConstraint.Relation,
                    relatedTo: NSLayoutConstraint.Attribute,
                    multiplier: CGFloat, constant: CGFloat)
}

extension HorizontalConstraint {
    /// A constraint from the leading edge of this view to the trailing edge of the 'toView'.
    static let leadingToTrailing = relative(attribute: .leading, relation: .equal, relatedTo: .trailing)
    /// A constraint from the trailing edge of this view to the leading edge of the 'toView'.
    static let trailingToLeading = relative(attribute: .trailing, relation: .equal, relatedTo: .leading)
    /// A constraint from the trailing edge of this view to the leading edge of the 'toView'.
    static let trailingToTrailing = relative(attribute: .trailing, relation: .equal, relatedTo: .trailing)
    /// A constraint from the bottom of this view to the bottom of the 'toView'.
    static let leadingToLeading = relative(attribute: .leading, relation: .equal, relatedTo: .leading)
    /// A horizontal constraint that attaches to the center Y axis of the view.
    static let centerY = relative(attribute: .centerY, relation: .equal, relatedTo: .centerY)

    static func relative(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        relatedTo: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1) -> (CGFloat) -> HorizontalConstraint {{
            .horizontal(attribute: attribute,
                        relation: relation,
                        relatedTo: relatedTo,
                        multiplier: multiplier, constant: $0)
        }}
}

// MARK: - VERTICAL CONSTRAINTS

enum VerticalConstraint {
    static let centerX = relative(attribute: .centerX, relation: .equal, relatedTo: .centerX)

    case vertical(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  relatedTo: NSLayoutConstraint.Attribute,
                  multiplier: CGFloat, constant: CGFloat)
}

extension VerticalConstraint {
    /// A constraint from the top of this view to the top of the 'toView'.
    static let topToBottom = relative(attribute: .top, relation: .equal, relatedTo: .bottom)
    /// A constraint from the top of this view to the bottom of the 'toView'.
    static let topToTop = relative(attribute: .top, relation: .equal, relatedTo: .top)
    /// A constraint from the bottom of this view to the top of the 'toView'.
    static let bottomToTop = relative(attribute: .bottom, relation: .equal, relatedTo: .top)
    /// A constraint from the bottom of this view to the bottom of the 'toView'.
    static let bottomToBottom = relative(attribute: .bottom, relation: .equal, relatedTo: .bottom)

    static func relative(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        relatedTo: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1) -> (CGFloat) -> VerticalConstraint {{
            .vertical(attribute: attribute, relation: relation,
                      relatedTo: relatedTo, multiplier: multiplier, constant: $0)
        }
        }
}

// MARK: - CONSTRAINT SET:

/// A Constraint Set is a predefined set of constraints to add to a view.
struct ConstraintSet {
    /// The constraints in a constraint set.
    let constraints: [Constraint]

    // SETS:

    /// Constrains the **Top**, **Leading**, and **Trailing** margins to a margin of zero.
    static let tlt = Self(constraints: [.top(0), .leading(0), .trailing(0)])
    /// Constrains the **Top**, **Leading**, **Bottom** and **Trailing** margins to a margin of zero.
    static let tlbt = Self(constraints: [.top(0), .leading(0), .bottom(0), .trailing(0)])
    /// Constrains to the **Top Margin**, **Leading**, **Bottom Margin**, and **Trailing** to a margin of zero.
    static let tmlbmt = Self(constraints: [.topMargin(0), .leading(0), .bottomMargin(0), .trailing(0)])

    /// Constrains the **Top**, **Leading,** **Bottom** and **Trailing**  to the margin passed.
    /// - Parameter margin: (CGFloat) Margin to constrain the set to.
    static func tlbt(margin: CGFloat) -> Self {
        Self(constraints: [.top(margin), .leading(margin), .bottom(-margin), .trailing(-margin)])
    }

    /// Constrains the **Top**, **Leading**, **Bottom** and **Trailing**  to the margin passed.
    /// - Parameter margin: (CGFloat) Margin to constrain the set to.
    static func tmlbmt(margin: CGFloat) -> Self {
        Self(constraints: [.topMargin(margin), .leading(margin), .bottomMargin(-margin), .trailing(-margin)])
    }
}

// MARK: - UIVIEW EXTENSION:

extension UIView {
    static let screenHeight = UIScreen.main.bounds.height
    static let halfScreenWidth = UIScreen.main.bounds.width/2

    func removeSuperConstraints(completion: () -> Void) {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }
        completion()
    }

    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)),
                          owner: self,
                          options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView, constraintSet: .tlbt(margin: 0))
        return contentView
    }

    func addSubview(_ subview: UIView, constraintSet: ConstraintSet) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.activate(constraints: constraintSet.constraints, relativeTo: self)
    }

    func addSubview(_ subview: UIView, constraints: [Constraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.activate(constraints: constraints, relativeTo: self)
    }

    enum AIEdge: Int {
        case top, left, bottom, right, topLeft, topRight, bottomLeft,
             bottomRight, all, none
    }

    func applyShadowWithCornerRadius(color: UIColor,
                                     opacity: Float,
                                     radius: CGFloat,
                                     edge: AIEdge,
                                     shadowSpace: CGFloat) {
        var offest: CGSize = .zero
        switch edge {
        case .top: offest = CGSize(width: 0, height: -shadowSpace)
        case .left: offest = CGSize(width: -shadowSpace, height: 0)
        case .bottom: offest = CGSize(width: 0, height: shadowSpace)
        case .right: offest = CGSize(width: shadowSpace, height: 0)
        case .topLeft: offest = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .topRight: offest = CGSize(width: shadowSpace, height: -shadowSpace)
        case .bottomLeft: offest = CGSize(width: -shadowSpace, height: shadowSpace)
        case .bottomRight: offest = CGSize(width: shadowSpace, height: shadowSpace)
        case .all: offest = CGSize(width: 0, height: 0)
        case .none: offest = CGSize.zero
        }

        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offest
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }

    @discardableResult func height(_ height: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = Constraint.constant(attribute: .height, relation: .equal, constant: height)
        return activate(constraint: constraint, priority: priority)
    }

    @discardableResult func width(_ width: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = Constraint.constant(attribute: .width, relation: .equal, constant: width)
        return activate(constraint: constraint, priority: priority)
    }

    @discardableResult
    func constrain(_ constraint: Constraint,
                   priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        precondition(superview != nil)
        return activate(constraint: constraint, relativeTo: superview, priority: priority)
    }

    @discardableResult
    func constrainVertically(to verticalView: UIView,
                             constraints: [VerticalConstraint]) -> [NSLayoutConstraint] {
        activate(verticalConstraints: constraints, relativeTo: verticalView)
    }

    @discardableResult func constrainHorizontally(to horizontalView: UIView,
                                                  constraints: [HorizontalConstraint]) -> [NSLayoutConstraint] {
        activate(horizontalConstraints: constraints, relativeTo: horizontalView)
    }

    @discardableResult func activate(constraint: Constraint,
                                     relativeTo item: UIView? = nil,
                                     priority: UILayoutPriority) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(from: self, to: item, constraint: constraint)
        newConstraint.priority = priority
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }

    func activate(constraints: [Constraint], relativeTo item: UIView? = nil) {
        let constraints = constraints.map { NSLayoutConstraint(from: self, to: item, constraint: $0) }
        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult func activate(verticalConstraints: [VerticalConstraint],
                                     relativeTo item: UIView? = nil) -> [NSLayoutConstraint] {
        let constraints = verticalConstraints.map { NSLayoutConstraint(from: self, to: item, constraint: $0) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult func activate(horizontalConstraints: [HorizontalConstraint],
                                     relativeTo item: UIView? = nil) -> [NSLayoutConstraint] {
        let constraints = horizontalConstraints.map { NSLayoutConstraint(from: self, to: item, constraint: $0) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

extension NSLayoutConstraint {

    convenience init(from: UIView, to item: UIView?, constraint: Constraint) {
        switch constraint {
        case let .constant(attribute: attr, relation: relation, constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: constant
            )
        case let .relative(attribute: attr,
                           relation: relation,
                           relatedTo: relatedTo,
                           multiplier: multiplier,
                           constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: item,
                attribute: relatedTo,
                multiplier: multiplier,
                constant: constant
            )
        }
    }

    convenience init(from: UIView, to item: UIView?, constraint: VerticalConstraint) {
        switch constraint {
        case let .vertical(attribute: attr,
                           relation: relation,
                           relatedTo: relatedTo,
                           multiplier: multiplier,
                           constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: item,
                attribute: relatedTo,
                multiplier: multiplier,
                constant: constant
            )
        }
    }

    convenience init(from: UIView, to item: UIView?, constraint: HorizontalConstraint) {
        switch constraint {
        case let .horizontal(attribute: attr,
                             relation: relation,
                             relatedTo: relatedTo,
                             multiplier: multiplier,
                             constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: item,
                attribute: relatedTo,
                multiplier: multiplier,
                constant: constant
            )
        }
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10, 10, -10, 10, -8, 8, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}
