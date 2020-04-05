//
//  MusicCell.swift
//  Vibe
//
//  Created by Eugene Lo on 3/26/20.
//  Copyright © 2020 Eugene Lo. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {
    var trackData: TrackData?
    var index = 0
    let albumCover = UIImageView()
    let name = UILabel()
    let artistName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        guard let tracks = trackData?.items else { return }
        let urlString = tracks[index].album.images[0].url
        guard let url = URL(string: urlString) else { return }
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            albumCover.image = image
        }
        else {
            albumCover.load(url: url, urlString: urlString)
        }
        
        name.text = tracks[index].name
        let artists = tracks[index].album.artists
        if artists.count > 0 {
            artistName.text = artists[0].name
        }
        
        let albumLength = frame.height
        albumCover.frame = .init(x: 0, y: 0, width: albumLength, height: albumLength)
        let nameOffset = albumLength + 12
        name.frame = .init(x: nameOffset, y: 0, width: frame.width - nameOffset, height: frame.height / 2)
        artistName.frame = .init(x: nameOffset, y: frame.height / 2, width: frame.width - nameOffset, height: frame.height / 2)
        addSubview(albumCover)
        name.font = UIFont(name: "OpenSans-Light", size: 18)
        name.translatesAutoresizingMaskIntoConstraints = false
        artistName.font = UIFont(name: "OpenSans-Light", size: 14)
        
        addSubview(name)
        addSubview(artistName)
    }
}

extension UIImageView {
    func load(url: URL, urlString: String) {
        //if image == nil {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
        //}
    }
}
