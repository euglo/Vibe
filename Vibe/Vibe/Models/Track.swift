//
//  TokenData.swift
//  Vibe
//
//  Created by Eugene Lo on 3/24/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import Foundation

struct TrackData: Decodable {
    let items: [Track]
}

struct Track: Decodable {
    let album: Album
    let name: String
    let id: String
    let href: String
}
