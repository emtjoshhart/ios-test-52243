//
//  NetworkError.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/19/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case emptyResponse
}
