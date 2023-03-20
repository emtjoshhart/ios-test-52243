//
//  SearchViewController.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit
import CoreData

/// The search view controller shows the user a collection view of movies that are returned when
/// the user has searched for a movie.
class SearchViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Movie>
    private let generator = UIImpactFeedbackGenerator(style: .light)
    /// Movies that are discovered during a search.
    private var discoveredMovies: [Movie] = []

    /// Movies that have been saved to core data, the user has marked these as 'watched'.
    private var watchedMovies: [Movie] {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return []
        }
        return fetchedObjects.compactMap {
            guard let title = $0.title,
                  let year = $0.year,
                  let imdbID = $0.imdbID,
                  let urlString = $0.posterString else { return nil }
            return Movie(title: title,
                         year: year,
                         posterUrlString: urlString,
                         imdbID: imdbID,
                         type: "movie")
        }
    }

    // MARK: - INITIALIZERS:

    init() {
        super.init(nibName: nil, bundle: nil)
        self.buildUI()
        try? fetchedResultsController.performFetch()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    // MARK: LIFECYCLE EVENTS:

    override func loadView() {
        self.view = gradientView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateSnapshot()
    }

    // MARK: - BUILD UI:

    private func buildUI() {
        view.addSubview(segmentedControl, constraints: [.centerX(0), .topMargin(0)])
        view.addSubview(collectionView,
                        constraints: [.leading(20), .trailing(-20), .bottomMargin(-20)])
        collectionView.constrainVertically(to: segmentedControl, constraints: [.topToBottom(16)])
    }

    // MARK: - UI COMPONENTS:

    /// The collection view utilized to show movies to the user.
    private lazy var collectionView: MovieCollectionView = {
        let collectionV = MovieCollectionView(frame: view.frame)
        collectionV.delegate = self
        return collectionV
    }()

    /// The search controller that appears in the navigational bar and allows the user
    /// to search the movie database:
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Search for movies..."
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.searchTextField.textColor = .babyBlue
        search.searchBar.tintColor = .babyBlue
        search.delegate = self
        search.searchBar.delegate = self
        return search
    }()

    /// Manages the results of the WatchedMovie objects in core data.
    private lazy var fetchedResultsController: NSFetchedResultsController<WatchedMovie> = {
        let controller = DataManager.watchedMovieFetchController()
        controller.delegate = self
        return controller
    }()

    /// The segmented control that allows you to change between Discover and Watched.
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Discover", "Watched"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentTintColor = .midnightBlue
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        let textColor: UIColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor
        ]
        control.height(44)
        control.width(210)
        control.setTitleTextAttributes(attributes, for: .normal)
        control.setTitleTextAttributes(attributes, for: .selected)
        return control
    }()

    /// Our beautious background view for our search view controller.
    private lazy var gradientView: GradientView = {
        GradientView(topColor: .slateBlue, bottomColor: .midnightBlue)
    }()

    // MARK: - COLLECTION VIEW RELOAD DATA:

    /// Updates the Collection View with discovered movies or watched movies.
    private func updateSnapshot(animated: Bool = true) {
        guard collectionView.window != nil else { return }

        let showDiscover = segmentedControl.selectedSegmentIndex == 0
        let moviesToShow = showDiscover ? discoveredMovies : watchedMovies

        if moviesToShow.isEmpty {
            collectionView.showEmptyMessage(showDiscover ? .discover : .watched)
        }

        if !moviesToShow.isEmpty { collectionView.restore() }

        var snapshot = Snapshot()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(moviesToShow)

        datasource.apply(snapshot, animatingDifferences: animated)
    }

    // MARK: - DIFFABLE DATA SOURCE:

    private lazy var datasource: DataSource = {
        DataSource(collectionView: collectionView) { (collectionView, itemPath, movie) in
            let cell = collectionView.dq(type: MovieCollectionCell.self, itemPath: itemPath)
            cell.setup(title: movie.title, imageUrlString: movie.posterUrlString)
            return cell
        }
    }()

    // MARK: - NETWORKING:

    /// Fetches movie results utilizing the provided text from the OMDB service.
    /// - Parameter searchText: (String) The text used to search with.
    private func fetchResults(searchText: String) {
        MovieService.searchMovies(searchText: searchText) {[weak self] results in
            if case .success(let movies) = results {
                DispatchQueue.main.async {
                    self?.discoveredMovies = movies
                    self?.updateSnapshot()
                }
            }
        }
    }

    // MARK: - ACTIONS:

    /// Called whenever the value of the segmented controller changes value.
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        searchController.searchBar.isHidden = sender.selectedSegmentIndex != 0
        self.updateSnapshot()
    }
}

// MARK: - SEARCH CONTROLLER & BAR DELEGATE:

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.discoveredMovies = []
        self.updateSnapshot()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard segmentedControl.selectedSegmentIndex == 0 else { return }

        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let text, !text.isEmpty else {
            self.discoveredMovies = []
            self.updateSnapshot()
            return
        }

        self.fetchResults(searchText: text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard segmentedControl.selectedSegmentIndex == 0 else { return }
        if searchText.count == 0 || searchText.count == 1 { return }
        self.fetchResults(searchText: searchText)
    }
}

// MARK: - COLLECTION VIEW DELEGATE:

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionCell else { return }

        cell.showLoadingIndicator(true)
        // Resign keyboard:
        self.searchController.searchBar.searchTextField.resignFirstResponder()
        // Give user feedback that they 'did' tap.
        self.generator.impactOccurred()
        // Deselect the collectionView cell.
        collectionView.deselectItem(at: indexPath, animated: false)

        guard let movie = datasource.itemIdentifier(for: indexPath) else { return }

        MovieService.getMovieDetails(imdbId: movie.imdbID) { [weak self] result in
            DispatchQueue.main.async {
                defer { cell.showLoadingIndicator(false) }

                switch result {
                case .success(let details):
                    let detailsVC = MovieDetailsViewController(movie: movie, details: details)
                    self?.present(detailsVC, animated: true)
                case .failure(let error):
                    self?.showErrorAlert(error: error)
                }
            }
        }
    }

    /// Shows an error to the user.
    private func showErrorAlert(error: Error) {
        let defaultText = "An unknown error occurred."
        let msg = error.asAFError != nil ? error.asAFError!.localizedDescription : defaultText
        let alertController = UIAlertController(title: "Uh Oh", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CORE DATA UPDATES:

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard segmentedControl.selectedSegmentIndex == 1 else { return }
        updateSnapshot()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot(animated: true)
    }
}
