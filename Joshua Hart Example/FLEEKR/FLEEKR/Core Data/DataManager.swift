//
//  DataManager.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import UIKit
import CoreData

/// Data Manager manages content being saved to Core Data.
class DataManager {
    /// Reference to the data model:
    private static let dataController = DataController(modelName: "FLEEKR")
    /// Loaded in App Delegate.
    static func load() { dataController.load() }

    // MARK: - FETCH WATCHED MOVIES:

    /// Sets up the fetched results controller for watched movies.
    /// - Returns: Returns the NSFetchedResultController for a collection of watched movies.
    static func watchedMovieFetchController() -> NSFetchedResultsController<WatchedMovie> {
        let fetchRequest: NSFetchRequest<WatchedMovie> = WatchedMovie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: dataController.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }

    /// Fetch WatchedMovie Core Data Type
    /// - Returns: ([WatchedMovie])  Collection of Watched Movies.
    static func fetchWatchedMovies() -> [WatchedMovie] {
        let fetchRequest: NSFetchRequest<WatchedMovie> = WatchedMovie.fetchRequest()
        guard let watchedMovies = try? dataController.viewContext.fetch(fetchRequest) else {
            return []
        }
        return watchedMovies
    }

    // MARK: - SAVE WATCHED MOVIE:

    /// Save a movie to CoreData as a watched movie.
    /// - Parameter movieDetails: (MovieDetails) The details model of the movie.
    /// - Returns: (Discardable) The newly saved watched movie.
    @discardableResult static func saveAsWatchedMovie(movieDetails: MovieDetails) -> WatchedMovie {
        let movie = WatchedMovie(context: self.dataController.viewContext)
        movie.posterString = movieDetails.poster
        movie.year = movieDetails.year
        movie.title = movieDetails.title
        movie.rated = movieDetails.rated
        movie.rating = movieDetails.rating ?? 0.0
        movie.language = movieDetails.language
        movie.imdbID = movieDetails.imdbID
        movie.genres = movieDetails.genre
        movie.plot = movieDetails.plot

        for actor in movieDetails.performingActors {
            let movieActor = WatchedMovieActor(context: self.dataController.viewContext)
            movieActor.name = actor.fullName
            movie.addToCast(movieActor)
        }

        movie.dateAdded = Date()
        save()
        return movie
    }

    // MARK: - GENERAL SAVE:

    static func save() {
        dataController.viewContext.performAndWait {
            if self.dataController.viewContext.hasChanges {
                try? self.dataController.viewContext.save()
            }
        }
    }

    // MARK: - FIND WATCHED MOVIE:

    /// Finds a watched movie in CoreData using a the movie title and imdbId object.
    /// - Parameter movieDetails: (MovieDetails) The details model of the movie.
    /// - Returns: (WatchedMovie?) The found watched movie, or nil if not found.
    static func getWatchedMovie(by title: String, imdbId: String) -> WatchedMovie? {
        let context = self.dataController.viewContext
        let fetchRequest: NSFetchRequest<WatchedMovie> = WatchedMovie.fetchRequest()

        // Set the predicate to match the unique identifier
        fetchRequest.predicate = NSPredicate(format: "title == %@ && imdbID == %@", title, imdbId)

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching watched movie: \(error)")
            return nil
        }
    }

    // MARK: - DELETE WATCHED MOVIE:

    /// Delete a watched movie and its related actors from CoreData.
    /// - Parameter watchedMovie: (WatchedMovie) The watched movie to be deleted.
    static func deleteWatchedMovie(_ watchedMovie: WatchedMovie) {
        let context = self.dataController.viewContext

        // Delete related actors
        if let cast = watchedMovie.cast {
            for actor in cast {
                if let movieActor = actor as? WatchedMovieActor {
                    context.delete(movieActor)
                }
            }
        }

        // Delete the watched movie
        context.delete(watchedMovie)
        save()
    }

    // MARK: - DELETE ALL:

    static func deleteAllData() {
        dataController.clearDatabase()
    }
}
