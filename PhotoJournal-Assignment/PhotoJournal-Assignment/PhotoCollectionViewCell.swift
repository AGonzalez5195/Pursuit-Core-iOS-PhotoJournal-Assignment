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
    
    func configureCell(from photo: Photo){
        self.layer.cornerRadius = 20
        photoImage.layer.cornerRadius = 5
        photoImage.image = UIImage(named: photo.imageName)
        photoDescription.text = photo.description
    }
}
