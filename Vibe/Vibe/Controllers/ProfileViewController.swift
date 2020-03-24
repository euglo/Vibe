//
//  ProfileViewController.swift
//  Vibe
//
//  Created by Eugene Lo on 3/23/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    let label = UILabel()
    //var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        label.text = "Hello"
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
