//
//  ViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    var allPhotos = [Photo]() {
        didSet {
            pictureCollectionView.reloadData()
        }
    }
    
    func loadData(){
        allPhotos = Photo.getPictures()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let specificPhoto = allPhotos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PhotoCollectionViewCell
        cell.configureCell(from: specificPhoto)
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370  , height: 393)
    }
}
