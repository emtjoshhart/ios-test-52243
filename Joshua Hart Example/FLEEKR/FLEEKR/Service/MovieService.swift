//
//  MovieService.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import Foundation
import Alamofire
import Network
import UIKit

class MovieService {
    typealias MovieResult = ((Result<[Movie], Error>) -> Void)
    typealias DetailsResult = ((Result<MovieDetails, Error>) -> Void)
    typealias ActorResult = ((Result<Actor, Error>) -> Void)
    typealias ActorImageResult = ((Result<UIImage, Error>) -> Void)

    /// Search for movies in the OMDB database using the search text.
    /// - Parameter searchText: (String) The text to search the DB with.
    /// - Parameter completion: (MovieResult) Success gives you a collection of movies, and well an error if it fails.
    static func searchMovies(searchText: String,
                             completion: @escaping MovieResult) {
        let params = ServiceConstants.searchParam(searchText)

        AF.request(ServiceConstants.omdEndpoint,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default)
        .responseDecodable(of: MoviesResponse.self) { response in
            switch response.result {
            case .success(let searchResult):
                completion(.success(searchResult.search))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Retrieve the movie details in the OMDB database using the imdbId.
    /// - Parameter imdbId: (String) The imdb identifier to get the details for.
    /// - Parameter completion: (DetailsResult) Success gives you a collection of movie details, and well an error if it fails.
    static func getMovieDetails(imdbId: String,
                                completion: @escaping DetailsResult) {
        let params = ServiceConstants.detailsParam(imdbId)

        AF.request(ServiceConstants.omdEndpoint,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default)
        .responseDecodable(of: MovieDetails.self) { response in
            switch response.result {
            case .success(let details):
                completion(.success(details))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Consists of two network calls, one to find the actor and another to get that actors image.
    /// - Parameter actorName: (String) The name of the actor you want the image for.
    /// - Parameter completion: (ActorImageResult) Success gives you an image of the actor, and well an error if it fails.
    static func getActorImage(actorName: String,
                              completion: @escaping ActorImageResult) {
        AF.request(ServiceConstants.actorEndpoint,
                   parameters: ServiceConstants.actorParams(actorName))
        .responseDecodable(of: ActorSearchResponse.self) { response in
            switch response.result {
            case .success(let actorSearchResponse):

                guard let actor = actorSearchResponse.results.first else {
                    completion(.failure(NetworkError.emptyResponse))
                    return
                }

                guard let path = actor.profile_path, path.isEmpty == false else {
                    completion(.failure(NetworkError.emptyResponse))
                    return
                }

                getActorImage(path, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// If you already know the profile path name, go ahead and get the actor image without the other call.
    /// - Parameter actorProfilePath: (String) The profile path used to get the url address of the image.
    /// - Parameter completion: (ActorImageResult) Success gives you an image of the actor, and well an error if it fails.
    static func getActorImage(_ actorProfilePath: String,
                              completion: @escaping ActorImageResult) {
        let imageUrl = ServiceConstants.imageBaseURL + actorProfilePath

        AF.request(imageUrl).responseData { response in
            switch response.result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
