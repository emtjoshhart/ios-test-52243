//
//  Actor.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import Foundation

struct Actor: Decodable {
    let id: Int?
    let name: String?
    let profile_path: String?
}

struct ActorSearchResponse: Decodable {
    let results: [Actor]
}
