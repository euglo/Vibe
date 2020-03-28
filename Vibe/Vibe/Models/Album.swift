//
//  Album.swift
//  Vibe
//
//  Created by Eugene Lo on 3/24/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let artists: [Artist]
    let images: [AlbumImage]
    let href: String
    let name: String
}

struct AlbumImage: Decodable {
    let height: Int
    let width: Int
    let url: String
}
