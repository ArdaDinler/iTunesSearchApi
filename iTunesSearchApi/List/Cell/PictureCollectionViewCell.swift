//
//  PictureCollectionViewCell.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var thumbnailView: UIImageView!

  var picture: Picture? {
    didSet {
      thumbnailView.image = picture?.thumbnail
    }
  }
}

