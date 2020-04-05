//
//  SignupView.swift
//  Vibe
//
//  Created by Eugene Lo on 3/29/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class SignupView: UIView {
    let label = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Don't have an account yet?"
        label.font = UIFont(name: "OpenSans-Light", size: 18)
        
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 18)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)

        addSubview(label)
        addSubview(button)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let spacing: CGFloat = 8
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: spacing),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

let signupView: UIView = {
    let sv = UIView()
    let label = UILabel()
    label.text = "Don't have an account yet?"
    label.font = UIFont(name: "OpenSans-Light", size: 18)
    let button = UIButton()
    button.setTitle("Sign Up", for: .normal)
    button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 18)
    
    sv.addSubview(label)
    sv.addSubview(button)
    
    label.frame = CGRect(origin: .init(x: 0, y: 0), size: label.intrinsicContentSize)
    button.frame = CGRect(origin: .init(x: label.frame.maxX + 8, y: 0), size: button.intrinsicContentSize)
    
    return sv
}()
