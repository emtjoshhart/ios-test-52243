//
//  MovieDetailsViewController.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    let movie: Movie
    let actors: [ActorName]
    let details: MovieDetails
    private let generator = UIImpactFeedbackGenerator(style: .heavy)

    // MARK: - INITIALIZERS:

    init(movie: Movie, details: MovieDetails) {
        self.movie = movie
        self.details = details
        self.actors = details.performingActors
        super.init(nibName: nil, bundle: nil)
        self.buildUI()
        self.setup(imageUrlString: movie.posterUrlString)
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: - LIFE CYCLE EVENTS:

    override func loadView() {
        self.view = gradientView
    }

    private func buildUI() {
        self.view.addSubview(scrollView, constraintSet: .tlbt(margin: 0))
    }

    // MARK: - PRIVATE FUNCTIONS:

    /// Loads the image for the movie, and then the cast members.
    private func setup(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        movieImageView.kf.setImage(
            with: url,
            placeholder: #imageLiteral(resourceName: "no_movie_image"),
            options: [
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ])
        castView.getActorImages()
    }

    // MARK: - ACTIONS:

    /// What happens when the user taps the watch button.
    @objc private func watchedButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        guard let imdbId = details.imdbID else {
            // Should throw an error here
            return
        }

        let watchedMovie = DataManager.getWatchedMovie(by: details.title,
                                                       imdbId: imdbId)
        let alreadyExists = watchedMovie != nil

        if sender.isSelected, !alreadyExists {
            generator.impactOccurred()
            self.showWatchedStatus(wasAdded: true)
            DataManager.saveAsWatchedMovie(movieDetails: self.details)
            return
        }

        guard let watchedMovie = watchedMovie else {
            print("Movie is already deleted.")
            return
        }

        generator.impactOccurred()
        self.showWatchedStatus(wasAdded: false)
        DataManager.deleteWatchedMovie(watchedMovie)
    }

    // MARK: - UI COMPONENTS:

    /// Scroll view because the plot text height is dynamic.
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: view.bounds)
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        let contentLG = scroll.contentLayoutGuide
        let frameLG = scroll.frameLayoutGuide
        scroll.addSubview(containerView, constraints: [])
        containerView.leadingAnchor.constraint(equalTo: contentLG.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentLG.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentLG.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentLG.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: frameLG.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: frameLG.trailingAnchor).isActive = true
        return scroll
    }()

    /// Container of UI elements that will be pinned to the scroll view.
    private lazy var containerView: UIView = {
        let container = UIView()

        // MOVIE IMAGE:
        container.addSubview(movieImageView, constraints: [.trailing(-10), .top(20)])

        // TITLE:
        container.addSubview(titleView, constraints: [.leading(20), .trailing(0)])
        titleView.constrainVertically(to: movieImageView, constraints: [.topToBottom(30)])

        // CAST:
        container.addSubview(castView, constraints: [.leading(0), .trailing(0)])
        castView.constrainVertically(to: titleView, constraints: [.topToBottom(30)])

        // PLOT:
        container.addSubview(plotView, constraints: [.leading(40), .bottomMargin(-10), .trailing(-16)])
        plotView.constrainVertically(to: castView, constraints: [.topToBottom(20)])

        // RATED REVIEW STARS:
        let ratingView = StarRatingView(rating: details.rating ?? 0.0)
        container.addSubview(ratedLabel, constraints: [.leading(5)])
        ratedLabel.constrainHorizontally(to: movieImageView, constraints: [.trailingToLeading(-5)])
        ratedLabel.constrainVertically(to: movieImageView, constraints: [.topToTop(16)])
        container.addSubview(ratingView, constraints: [.height(160), .width(32.5)])
        ratingView.constrainVertically(to: ratedLabel, constraints: [.centerX(0), .topToBottom(10)])

        // WATCHED BUTTON:
        container.addSubview(watchedButton, constraints: [])
        watchedButton.constrainVertically(to: ratingView, constraints: [.topToBottom(16), .centerX(0)])

        // LANGUAGE AND RATED:
        container.addSubview(langRatingView, constraints: [.leading(5)])
        langRatingView.constrainHorizontally(to: movieImageView, constraints: [.trailingToLeading(-5)])
        langRatingView.constrainVertically(to: watchedButton, constraints: [.topToBottom(16)])

        // RUNTIME:
        container.addSubview(runtimeView, constraints: [.leading(5)])
        runtimeView.constrainHorizontally(to: movieImageView, constraints: [.trailingToLeading(-5)])
        runtimeView.constrainVertically(to: langRatingView, constraints: [.topToBottom(16)])

        return container
    }()

    /// The view that shows the cast memebers in a horizontal scroll view.
    private lazy var castView: CastView = {
        CastView(actors: details.performingActors)
    }()

    /// The view that shows the movie's summary/plot text.
    private lazy var plotView: PlotView = {
        PlotView(summary: details.plot)
    }()

    /// The view that shows the movie's title.
    private lazy var titleView: TitleView = {
        TitleView(title: movie.title)
    }()

    /// The language and rating view.
    private lazy var langRatingView: UIView = {
        LanguageAndRatingView(language: details.language, rated: details.rated)
    }()

    /// Shows a status to the user about whether the movie was added or removed from core data.
    private lazy var watchedStatusView: WatchedStatusView = { WatchedStatusView() }()

    /// The watched button that allows the user to add or remove the movie from their watched list.
    private lazy var watchedButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "watched"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "not_watched"), for: .normal)
        button.height(48)
        button.width(48)
        if let imdbId = details.imdbID {
            let watchedMovie = DataManager.getWatchedMovie(by: details.title, imdbId: imdbId)
            button.isSelected = watchedMovie != nil
        }
        button.addTarget(self, action: #selector(watchedButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    /// Shows the runtimes and genres of the movie.
    private lazy var runtimeView: UIView = {
        RuntimeAndGenreView(runtime: details.runtime, genre: details.genre)
    }()

    /// Our beautious background view for our search view controller.
    private lazy var gradientView: GradientView = {
        GradientView(topColor: .slateBlue, bottomColor: .midnightBlue)
    }()

    /// The image view that shows the movie's poster image.
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                          multiplier: 3 / 2).isActive = true

        imageView.width(UIScreen.main.bounds.width - 100)
        return imageView
    }()

    /// Just shows the word "RATED" above the star rating view.
    private lazy var ratedLabel: UILabel = {
        let label = UILabel()
        label.text = "RATED"
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 16)
        label.textColor = .babyBlue
        return label
    }()

    /// Displays a view over the movie image view that shows the user that they have added
    /// or removed a title from the watched list.
    private func showWatchedStatus(wasAdded: Bool) {
        DispatchQueue.main.async {
            guard self.watchedStatusView.superview == nil else { return }
            self.watchedStatusView.alpha = 0
            self.watchedStatusView.update(wasAdded: wasAdded)
            self.movieImageView.addSubview(self.watchedStatusView, constraintSet: .tlbt(margin: 0))

            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut) {
                self.watchedStatusView.alpha = 1.0
            } completion: { _ in
                self.removeWatchedStatusWithAnimation()
            }
        }
    }

    /// Removes the watched status view after a delay of 2 seconds.
    private func removeWatchedStatusWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut) {
                self.watchedStatusView.alpha = 0
            } completion: { _ in
                DispatchQueue.main.async {
                    self.watchedStatusView.removeFromSuperview()
                    self.watchedStatusView.alpha = 1.0
                }
            }
        }
    }
}
