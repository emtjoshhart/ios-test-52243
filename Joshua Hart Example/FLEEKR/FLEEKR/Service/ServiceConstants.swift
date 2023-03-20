//
//  Constant.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import Foundation
import Alamofire

struct ServiceConstants {
    static let omdbAPIKey = "50ab6f15"
    static let omdEndpoint = "https://www.omdbapi.com/"

    static let apiKeyParam: [String: String] = ["apikey": omdbAPIKey]

    // MARK: - SEARCH MOVIES:

    static func searchParam(_ text: String) -> [String: String] {
        ["s": text, "type": "movie", "apikey": omdbAPIKey]
    }

    // MARK: - GET MOVIE DETAILS:

    static func detailsParam(_ identifier: String) -> [String: String] {
        ["i": identifier, "type": "movie", "plot": "full", "apikey": omdbAPIKey]
    }

    // MARK: - GET ACTOR DETAILS:

    static let actorAPIKey = "ba12db25991cd8981c6713d8c28deea1"
    static let actorEndpoint = "https://api.themoviedb.org/3/search/person"
    static func actorParams(_ actor: String) -> [String: String] {
        ["query": actor, "api_key": actorAPIKey]
    }

    // MARK: - GET ACTOR IMAGES:

    static let imageBaseURL = "https://image.tmdb.org/t/p/w92"

}
