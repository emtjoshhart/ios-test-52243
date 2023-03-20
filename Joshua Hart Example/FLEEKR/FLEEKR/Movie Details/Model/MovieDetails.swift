//
//  MovieDetails.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import Foundation

struct MovieDetails: Codable, Hashable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String?
    let poster: String?
    let ratings: [Rating]?
    let metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let type: String?
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(imdbID)
    }

    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.imdbID == rhs.imdbID
    }

    var performingActors: [ActorName] {
        let arrayOfActors = actors.components(separatedBy: ", ")
        guard !arrayOfActors.isEmpty else { return [] }
        return arrayOfActors.compactMap {
            let names = $0.components(separatedBy: " ")
            if names[0] == "N/A" { return nil }
            return ActorName(firstName: names[0], lastName: names.last ?? "")
        }
    }

    var rating: Double? {
        guard let imdbRating = imdbRating else { return nil }
        guard let doubleRating = Double(imdbRating) else { return nil }
        return doubleRating/2
    }
}

struct Rating: Codable, Hashable {
    let source: String?
    let value: String?
}

struct ActorName: Hashable {
    let firstName: String
    let lastName: String

    var fullName: String {
        firstName + " " + lastName
    }
}
