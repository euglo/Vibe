//
//  Artist.swift
//  Vibe
//
//  Created by Eugene Lo on 3/24/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import Foundation

struct ArtistData: Decodable {
    let items: [Artist]
}

struct Artist: Decodable {
    let name: String
    let id: String
    let href: String
    let images: [AlbumImage]?
}


