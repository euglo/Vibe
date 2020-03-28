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
    let spotifyManager = SpotifyManager.shared
    
    let spotifyButton: UIButton = {
        let button = UIButton()
        let padding: CGFloat = 12
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(red: 0.11, green: 0.73, blue: 0.33, alpha: 1.0)
        button.setImage(UIImage(named: "Spotify_Logo_RGB_White"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
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

        setupLayout()
    }
    
    // MARK: Handler functions
    @objc func tappedSpotifyButton(_ sender: UIButton) {
        let scope = "user-read-private user-read-email user-top-read"
        
        let queryDict: [String: String] = [
            "response_type": "code",
            "client_id": spotifyManager.getClientID(),
            "scope": scope,
            "redirect_uri": spotifyManager.getRedirectURL()
        ]
        
        let myURL = URL(string: "https://accounts.spotify.com/authorize?" + queryString(queryDict: queryDict))!
        let scheme = "vibe-login"
        
        let session = ASWebAuthenticationSession(url: myURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            
            if let code = queryItems?.filter({ $0.name == "code" }).first?.value {
                self.spotifyManager.setCode(code: code)
                self.spotifyManager.getToken {
                    let tableVC = TableViewController()
                    let navigation = UINavigationController(rootViewController: tableVC)
                    navigation.modalPresentationStyle = .fullScreen
                    navigation.modalTransitionStyle = .crossDissolve
                    self.present(navigation, animated: true, completion: nil)
                }
            }
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(spotifyButton)
        view.addSubview(connectLabel)
        
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
