//
//  ActorView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import UIKit

class ActorView: UIView {
    let actorName: ActorName
    let image: UIImage

    init(actorName: ActorName, image: UIImage) {
        self.actorName = actorName
        self.image = image
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(actorImageView, constraints: [.top(0), .centerX(0)])
        self.addSubview(actorNameLabel, constraints: [.leading(0), .bottom(0), .trailing(0)])
        actorNameLabel.constrainVertically(to: actorImageView, constraints: [.topToBottom(5)])
        actorImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    private lazy var actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.height(80)
        imageView.width(80)
        return imageView
    }()

    private lazy var actorNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .pastelBlue
        label.height(17)
        label.text = actorName.fullName
        return label
    }()
}
