//
//  HeaderView.swift
//  Vibe
//
//  Created by Eugene Lo on 3/25/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    let label = UILabel()
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont(name: "OpenSans-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let constraints = [
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
