//
//  UICollectionView+DF.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit

extension UICollectionView {
    func dq<T: UICollectionViewCell>(type: T.Type, itemPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier,
                                             for: itemPath) as? T else {
            fatalError("Cell Error: \(type.reuseIdentifier) at indexPath: \(itemPath) is not \(T.self)")
        }
        return cell
    }

    enum EmptyDestination {
        case discover
        case watched
    }

    func showEmptyMessage(_ destination: EmptyDestination) {
        if backgroundView != nil { restore() }
        let gradient = Self.gradientBackground()
        let imageView = Self.emptyBirdImageView(destination)
        let title = Self.titleLabel(destination: destination)
        let description = Self.descriptionLabel(destination: destination)
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(imageView, constraints: [.top(20), .centerX(0)])
        container.addSubview(title, constraints: [.leading(0), .trailing(0)])
        title.constrainVertically(to: imageView, constraints: [.topToBottom(30)])
        container.addSubview(description, constraints: [.leading(0), .bottom(0), .trailing(0)])
        description.constrainVertically(to: title, constraints: [.topToBottom(16)])
        gradient.addSubview(container, constraints: [.centerY(0), .centerX(0), .leading(40)])
        self.backgroundView = gradient
    }

    static func titleLabel(destination: EmptyDestination) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .pastelBlue
        label.font = UIFont(name: "Futura-Bold", size: 24)
        switch destination {
        case .discover: label.text = "Start a Search"
        case .watched: label.text = "No Watched Movies"
        }
        return label
    }

    static func descriptionLabel(destination: EmptyDestination) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .pastelBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Futura", size: 15)
        switch destination {
        case .discover:
            label.text = "You can try searching for\ntitles using the search bar."
        case .watched:
            label.text = "You can tap the watched icon on a\nmovie's detail page to add it to\nyour watched list."
        }
        return label
    }

    static func emptyBirdImageView(_ destination: EmptyDestination) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = destination == .discover ? #imageLiteral(resourceName: "empty") : #imageLiteral(resourceName: "emptyBird")
        imageView.height(236)
        imageView.width(300)
        return imageView
    }

    static func gradientBackground() -> GradientView {
        GradientView(topColor: .stormCloud, bottomColor: .midnightBlue)
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String { NSStringFromClass(self) }
}
