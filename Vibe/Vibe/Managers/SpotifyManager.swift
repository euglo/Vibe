//
//  SpotifyData.swift
//  Vibe
//
//  Created by Eugene Lo on 3/23/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import Foundation
import Alamofire

protocol SpotifyManagerDelegate {
    func didGetSpotifyData()
}

class SpotifyManager {
    private let SpotifyClientID = "4ad4037801ea4fc29733f59132a872a3"
    private let SpotifyClientSecret = "a63558cbcdc442358d43dbe20aca27de"
    private let SpotifyRedirectURL = "vibe-login://spotify-login-callback"
    
    private var code: String?
    private var timer: Timer?
    private var tokenData: TokenData?
    private var refreshToken: String?
    private var elapsed = 0
    var trackData: TrackData?
    var artistData: ArtistData?
    
    var delegate: SpotifyManagerDelegate?
    
    func getClientID() -> String {
        return SpotifyClientID
    }
    
    func getRedirectURL() -> String {
        return SpotifyRedirectURL
    }
    
    func fetchData(code: String) {
        self.code = code
        
        let parameters: [String: String] = [
            "code": code,
            "redirect_uri": SpotifyRedirectURL,
            "grant_type": "authorization_code",
            "client_id": SpotifyClientID,
            "client_secret": SpotifyClientSecret
        ]
        
        let group = DispatchGroup()
        group.enter()
        
        AF.request("https://accounts.spotify.com/api/token",
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseJSON { response in
                if let responseData = response.data {
                    self.parseJSON(data: responseData, type: .token)
                    self.refreshToken = self.tokenData?.refresh_token
                    self.setNewTimer()
                }
                group.leave()
            }
        
        group.notify(queue: .main) {
            self.getTracksAndArtists()
        }
    }
    
    func updateToken() {
        guard let myRefreshToken = refreshToken else {
            return debugPrint("Refresh token does not exist")
        }
        
        let parameters: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": myRefreshToken
        ]
        
        let str = "\(SpotifyClientID):\(SpotifyClientSecret)"
        let utf8Str = str.data(using: String.Encoding.utf8)
        
        guard let base64Encoded = utf8Str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Encoded)"
        ]

        AF.request("https://accounts.spotify.com/api/token",
               method: .post,
               parameters: parameters,
               encoder: URLEncodedFormParameterEncoder.default,
               headers: headers)
        .validate()
        .responseJSON { response in
            if let responseData = response.data {
                self.parseJSON(data: responseData, type: .token)
                self.setNewTimer()
            }
        }
    }
    
    func getTracksAndArtists() {
        guard let accessToken = tokenData?.access_token else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let group = DispatchGroup()

        for tag in ["tracks", "artists"] {
            group.enter()
            AF.request("https://api.spotify.com/v1/me/top/\(tag)",
                   headers: headers)
            .validate()
            .responseJSON { response in
                if let error = response.error {
                    print(error)
                }
                
                if let responseData = response.data {
                    let type: DataType = (tag == "tracks") ? .track : .artist
                    self.parseJSON(data: responseData, type: type)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.delegate?.didGetSpotifyData()
        }
    }
    
    @objc private func updateTimer() {
        elapsed += 1

        // Refresh token if it expires in 10 minutes
        if (tokenData?.expires_in ?? 0) - elapsed <= 360 {
            timer?.invalidate()
            self.updateToken()
        }
    }
    
    private func parseJSON(data: Data, type: DataType) {
        do {
            let decoder = JSONDecoder()
            switch type {
            case .token:
                self.tokenData = try decoder.decode(TokenData.self, from: data)
            case .track:
                self.trackData = try decoder.decode(TrackData.self, from: data)
            case .artist:
                self.artistData = try decoder.decode(ArtistData.self, from: data)
            }
        }
        catch {
            debugPrint("Could not decode data")
            return
        }
    }
    
    private func setNewTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
}
