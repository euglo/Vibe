//
//  TokenData.swift
//  Vibe
//
//  Created by Eugene Lo on 3/24/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import Foundation

struct TokenData: Decodable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
