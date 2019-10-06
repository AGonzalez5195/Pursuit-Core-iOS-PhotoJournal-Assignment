//
//  ViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    //MARK: -- IBActions
    @IBAction func toolBarButtonPressed(_ sender: UIBarButtonItem) {
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let addPhotoVC = MainStoryBoard.instantiateViewController(identifier: "AddPhotoVC") as! AddPhotoViewController
        let settingsVC = MainStoryBoard.instantiateViewController(identifier: "SettingsVC") as! SettingsViewController
        
        if sender.tag == 0 {
//            addPhotoVC.modalPresentationStyle = .overCurrentContext
            self.present(addPhotoVC, animated: true, completion: nil)
            addPhotoVC.delegate = self
            addPhotoVC.delegate = self
        } else {
            self.present(settingsVC, animated: true, completion: nil)
        }
    }
    
    
    //MARK: -- Properties
    var allPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.pictureCollectionView.reloadData()
            }
        }
    }
    
    //MARK: -- Methods
    
    private func presentActionSheet(id: Int){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            DispatchQueue.global(qos: .utility).async {
                do {
                    try PhotoPersistenceHelper.manager.deletePhoto(withID: id)
                } catch {
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        self.allPhotos = try PhotoPersistenceHelper.manager.getPhotos()
                    } catch {
                    }
                }
            }
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            //Carry over the current Photo. Next screen should have the existing photo and description.
            //Save over the original one and insert it at the index the prior one was at.
            
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(editAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    private func loadPhotoJournal(){
        do {
            allPhotos = try PhotoPersistenceHelper.manager.getPhotos()
        } catch {
            print(error)
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoJournal()
        print(allPhotos)
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
        let image = UIImage(data: specificPhoto.image)
        
        cell.photoImage.image = image
        cell.buttonFunction = { self.presentActionSheet(id: specificPhoto.id) }
        return cell
        
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 470)
    }
}

extension PhotoViewController: loadUserDataDelegate {
    func loadUserJournal() {
        do {
            allPhotos = try PhotoPersistenceHelper.manager.getPhotos()
        } catch {
            print(error)
        }
    }
}

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 50)
//    }
//Use for horizontal shit


