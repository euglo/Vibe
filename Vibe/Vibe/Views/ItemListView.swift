//
//  ItemListView.swift
//  Vibe
//
//  Created by Eugene Lo on 3/25/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class ItemListView: UIView {
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        titleLabel.font = UIFont(name: "OpenSans-Bold", size: 32)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder init has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setTitle(value: String) {
        titleLabel.text = value
        setNeedsLayout()
    }
}
