//
//  ViewController.swift
//  Vibe
//
//  Created by Eugene Lo on 3/22/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    let SpotifyClientID = "4ad4037801ea4fc29733f59132a872a3"
    let SpotifyRedirectURL = "vibe-login://spotify-login-callback"
    
    let spotifyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(red: 0.11, green: 0.73, blue: 0.33, alpha: 1.0)
        button.setImage(UIImage(named: "Spotify_Logo_RGB_White"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedSpotifyButton), for: .touchUpInside)
        return button
    }()
    
    //let spotifyImage = UIImage(named: "Spotify_Logo_RGB_Green")
    let connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect to:"
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(spotifyButton)
        view.addSubview(connectLabel)
        
        setupLayout()
    }
    
    // MARK: Handler functions
    @objc func tappedSpotifyButton(_ sender: UIButton) {
        let scope = "user-read-private user-read-email"
        
        let queryDict: [String: String] = [
            "response_type": "code",
            "client_id": SpotifyClientID,
            "scope": scope,
            "redirect_uri": SpotifyRedirectURL
        ]
        
        let myURL = URL(string: "https://accounts.spotify.com/authorize?" + queryString(queryDict: queryDict))!
        let scheme = "vibe-login"
        
        let session = ASWebAuthenticationSession(url: myURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let code = queryItems?.filter({ $0.name == "code" }).first?.value ?? ""
            SpotifyData.shared.code = code
            
            let profileVC = ProfileViewController()
            //profileVC.code = code
            profileVC.modalPresentationStyle = .fullScreen
            profileVC.modalTransitionStyle = .crossDissolve
            self.present(profileVC, animated: true, completion: nil)
        }
        
        session.presentationContextProvider = self
        
        session.start()
    }
    
    // MARK: Helper functions
    private func queryString(queryDict: [String: String]) -> String {
        var result = ""
        
        for (key, value) in queryDict {
            let fragment = "\(key)=\(value)&"
            if let encodedFragment = fragment.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                result += encodedFragment
            }
        }
        result = String(result.dropLast())
        
        return result
    }
    
    private func setupLayout() {
        let constraints = [
            // Spotify button constraints
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height / 4)),
            spotifyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60),
            // Connect label constraints
            connectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectLabel.bottomAnchor.constraint(equalTo: spotifyButton.topAnchor, constant: -15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
