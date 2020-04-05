//
//  LoginViewController.swift
//  Vibe
//
//  Created by Eugene Lo on 3/28/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    let spotifyManager = SpotifyManager()
    let signupView = SignupView()
    
    let inputsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    let spotifyButton: UIButton = {
        let button = UIButton()
        let inset: CGFloat = 10
        button.backgroundColor = UIColor(red: 0.11, green: 0.73, blue: 0.33, alpha: 1.0)
        button.setImage(UIImage(named: "Spotify_Logo_RGB_White"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    let connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect to:"
        label.font = UIFont(name: "OpenSans-Bold", size: 20)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 18)
        button.backgroundColor = UIColor(red: 0.11, green: 0.73, blue: 0.33, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spotifyManager.delegate = self
        //view.backgroundColor = .systemYellow
        createGradientLayer()
        
        view.clipsToBounds = true

        connectLabel.isHidden = true
        
        spotifyButton.addTarget(self, action: #selector(tappedSpotifyButton), for: .touchUpInside)
        spotifyButton.isHidden = true
        
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        
        signupView.button.addTarget(self, action: #selector(tappedSignupButton), for: .touchUpInside)
        
        view.addSubview(inputsContainerView)
        view.addSubview(spotifyButton)
        view.addSubview(connectLabel)
        view.addSubview(loginButton)
        view.addSubview(signupView)
        
        setupLayout()
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemYellow.cgColor, UIColor.white.cgColor]
        
        view.layer.addSublayer(gradientLayer)
    }
    
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
                self.spotifyManager.fetchData(code: code)
            }
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    private func setupLayout() {
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        spotifyButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signupView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        let spacing: CGFloat = 12
        let buttonHeight: CGFloat = 50
        let inputsViewHeight: CGFloat = 150
        
        let constraints = [
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.heightAnchor.constraint(equalToConstant: inputsViewHeight),
            inputsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            inputsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            connectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectLabel.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: spacing),
            spotifyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            spotifyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.topAnchor.constraint(equalTo: connectLabel.bottomAnchor, constant: spacing),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: spotifyButton.bottomAnchor, constant: spacing),
            signupView.heightAnchor.constraint(equalToConstant: 50),
            signupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func tappedLoginButton() {
        print("Login button tapped")
    }
    
    @objc func tappedSignupButton() {
        spotifyButton.isHidden = false
        connectLabel.isHidden = false
        loginButton.isHidden = true
        signupView.isHidden = true
    }
    
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
}

// MARK: - ASWebAuthentication

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: - SpotifyManagerDelegate

extension LoginViewController: SpotifyManagerDelegate {
    func didGetSpotifyData() {
        let tableVC = TableViewController()
        tableVC.trackData = spotifyManager.trackData
        tableVC.artistData = spotifyManager.artistData
        
        let navigation = UINavigationController(rootViewController: tableVC)
        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve
        self.present(navigation, animated: true, completion: nil)
    }
}
