//
//  Movie.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import Foundation

/// The movies response is a response from the OMDB service call.
struct MoviesResponse: Codable {
    /// Contains our search results of movies:
    let search: [Movie]
    /// How many results were returned:
    let totalResults: String
    /// What our response was from the request:
    let response: String

    private enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}

/// Self explanatory, but contains movie objects returned in the MoviesResponse.
struct Movie: Codable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.title == rhs.title &&
        lhs.posterUrlString == rhs.posterUrlString &&
        lhs.uuidString == rhs.uuidString &&
        lhs.imdbID == rhs.imdbID
    }

    /// The service can return duplicate movies, in order to prevent
    /// the issue of clashing duplicate items in a deferable data sourced
    /// collection view, we create a random identifier marker.
    let uuidString = UUID().uuidString
    /// The title of the movie
    let title: String
    /// The release year of the movie
    let year: String
    /// The URL of the movie's poster image
    let posterUrlString: String
    /// The IMDb identifier for the movie
    let imdbID: String
    /// The type of content (e.g., movie, series)
    let type: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case posterUrlString = "Poster"
        case imdbID = "imdbID"
        case type = "Type"
    }
}
