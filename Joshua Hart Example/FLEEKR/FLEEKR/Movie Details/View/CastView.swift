//
//  CastView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit

class CastView: UIView {
    let actors: [ActorName]
    var actorImages = [ActorName: UIImage]()

    // MARK: - INITIALERS:

    init(actors: [ActorName]) {
        self.actors = actors
        super.init(frame: .zero)
        self.setupUI()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - SETUP UI:

    private func setupUI() {
        addSubview(topDividerView, constraints: [.leading(20), .top(0), .trailing(0)])

        addSubview(actorsScrollView, constraints: [.leading(60), .trailing(-16)])
        actorsScrollView.constrainVertically(to: topDividerView, constraints: [.topToBottom(20)])

        addSubview(starringCastLabel, constraints: [ .width(62), .height(30)])
        starringCastLabel.constrainHorizontally(to: actorsScrollView,
                                                constraints: [.centerY(0), .trailingToLeading(0)])

        addSubview(bottomDividerView, constraints: [.leading(20), .bottom(0), .trailing(0)])
        bottomDividerView.constrainVertically(to: actorsScrollView, constraints: [.topToBottom(20)])
    }

    private func populateActorImages() {
        let actorViews: [ActorView] = actorImages.compactMap {
            ActorView(actorName: $0.key, image: $0.value)
        }
        actorsScrollView.addArrangedViews(actorViews)
    }

    private func showNoActorsLabel() {
        DispatchQueue.main.async {
            self.noCastLabel.width(UIScreen.main.bounds.width - 76) // minus leading & trailing edges.
            self.actorsScrollView.addSubview(self.noCastLabel, constraints: [.leading(-10), .top(0)])
        }
    }

    // MARK: - UI COMPONENTS:

    private lazy var actorsScrollView: HorizontalScrollView = {
        let scrollView = HorizontalScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.interItemSpacing = 16
        scrollView.height(100)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var starringCastLabel: UILabel = {
        let label = UILabel()
        label.text = "CAST"
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 24)
        label.textColor = .slateBlue
        label.transform = CGAffineTransform(rotationAngle: -.pi/2)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var topDividerView: UIView = {
        let divider = UIView()
        divider.height(1)
        divider.backgroundColor = .slateBlue
        return divider
    }()

    private lazy var bottomDividerView: UIView = {
        let divider = UIView()
        divider.height(1)
        divider.backgroundColor = .slateBlue
        return divider
    }()

    private lazy var noCastLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 24)
        label.textAlignment = .center
        label.height(100)
        label.textColor = .slateBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "CAST\nUNAVAILABLE"
        return label
    }()

    // MARK: - NETWORKING:

    func getActorImages() {
        let totalActors = actors.count

        if totalActors == 0 {
            self.showNoActorsLabel()
            return
        }

        var completedRequests = 0

        for actor in actors {
            guard self.actorImages.keys.contains(actor) == false else { continue }

            MovieService.getActorImage(actorName: actor.fullName) { [weak self] result in
                defer {
                    completedRequests += 1
                    if completedRequests == totalActors {
                        if self?.actorImages.values.isEmpty == true {
                            self?.showNoActorsLabel()
                        }
                        self?.populateActorImages()
                    }
                }

                guard self?.actorImages.keys.contains(actor) == false else { return }
                if case .success(let actorImage) = result {
                    self?.actorImages[actor] = actorImage
                } else {
                    print("Failed")
                }
            }
        }
    }
}
