//
//  PhotoCollectionViewCell.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var photoDescription: UILabel!
    
    @IBOutlet weak var photoDateLabel: UILabel!
    
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    var buttonFunction: (()->())?
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if let closure = buttonFunction {
            closure()
        }
    }
    
    func configureCell(from photo: Photo){
        self.layer.cornerRadius = 20
        photoDescription.text = photo.description
        photoDateLabel.text = photo.date
        moreOptionsButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        let image = UIImage(data: photo.image)
        photoImage.image = image
    }
}
