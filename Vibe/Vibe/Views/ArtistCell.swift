//
//  MusicCell.swift
//  Vibe
//
//  Created by Eugene Lo on 3/26/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    var artistData: ArtistData?
    var index = 0
    let albumCover = UIImageView()
    let name = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        guard let artists = artistData?.items else { return }
        let urlString = artists[index].images?[0].url ?? ""
        guard let url = URL(string: urlString) else { return }
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            albumCover.image = image
        }
        else {
            albumCover.load(url: url, urlString: urlString)
        }

        name.text = artists[index].name
        
        let albumLength = frame.height
        albumCover.frame = .init(x: 0, y: 0, width: albumLength, height: albumLength)
        let nameOffset = albumLength + 12
        name.frame = .init(x: nameOffset, y: 0, width: frame.width - nameOffset, height: frame.height)

        addSubview(albumCover)
        name.font = UIFont(name: "OpenSans-Light", size: 18)
        addSubview(name)
    }
}

