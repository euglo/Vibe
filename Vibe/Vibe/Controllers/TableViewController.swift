//
//  NavigationViewController.swift
//  Vibe
//
//  Created by Eugene Lo on 3/27/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let tableLayout = [
        ["Top Tracks", "Top Artists"]
    ]
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableLayout[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = tableLayout[indexPath.section][indexPath.row]
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = HeaderView()
//        if section == 0 {
//            header.title = "Top"
//        }
//        return header
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let profileVC = ProfileViewController(collectionViewLayout: layout)
        if indexPath.row == 0 {
            profileVC.cellType = .track
            
        } else if indexPath.row == 1 {
            profileVC.cellType = .artist
        }
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableLayout.count
    }
}
