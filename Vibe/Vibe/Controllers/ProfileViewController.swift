//
//  ProfileViewController.swift
//  Vibe
//
//  Created by Eugene Lo on 3/23/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

struct CellData {
    let image: UIImage
    let text: String
}

var imageCache = NSCache<NSString, UIImage>()

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var trackData: TrackData?
    var artistData: ArtistData?
    
    let padding: CGFloat = 12
    let menuBarHeight: CGFloat = 50
    let trackID = "trackID"
    let artistID = "artistID"
    var cellType: DataType = .track
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cellType == .artist {
            navigationItem.title = "Top Artists"
        } else {
            navigationItem.title = "Top Tracks"
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //setupMenuBar()
        setupCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int
        if section == 0 {
            count = trackData?.items.count ?? 0
        }
        else {
            count = artistData?.items.count ?? 0
        }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .artist {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: artistID, for: indexPath) as! ArtistCell
            cell.index = indexPath.item
            cell.artistData = artistData
            cell.setupViews()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackID, for: indexPath) as! TrackCell
            cell.index = indexPath.item
            cell.trackData = trackData
            cell.setupViews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - (2 * padding), height: 56)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    private func setupMenuBar() {
        let menuBar = MenuBar()
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let constraints = [
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCollectionView() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 5
            layout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        }
        
        collectionView.backgroundColor = .systemBackground
        //collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        
        if cellType == .artist {
            collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: artistID)
        } else {
            collectionView.register(TrackCell.self, forCellWithReuseIdentifier: trackID)
        }
        
    }
    
}
