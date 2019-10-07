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
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    //MARK: -- Properties
    var allPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.pictureCollectionView.reloadData()
            }
        }
    }
    
    var isInDarkMode = Bool()
    
    //MARK: -- IBActions
    @IBAction func toolBarButtonPressed(_ sender: UIBarButtonItem) {
        let addPhotoVC = self.storyboard?.instantiateViewController(identifier: "AddPhotoVC") as! AddPhotoViewController
        let settingsVC = self.storyboard?.instantiateViewController(identifier: "SettingsVC") as! SettingsViewController
        
        if sender.tag == 0 {
            addPhotoVC.isInDarkmode = self.isInDarkMode
            self.present(addPhotoVC, animated: true, completion: nil)
            addPhotoVC.delegate = self
        } else {
            self.present(settingsVC, animated: true, completion: nil)
            settingsVC.delegate = self
        }
    }
    
    //MARK: -- Methods
    
    private func presentActionSheet(id: Int, photo: Photo) {
        print(id)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deletePhoto(with: id) }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.editPhoto(photoToEdit: photo)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {(action) in
            self.presentShareMenu(id: id)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    private func presentShareMenu(id: Int){
        let image = [UIImage(data: self.allPhotos[id].image)]
        let activityVC = UIActivityViewController(activityItems: image, applicationActivities: nil)
        self.present(activityVC,animated: true)
    }
    
    
    private func deletePhoto(with id: Int) {
        DispatchQueue.global(qos: .utility).async {
            do {
                try PhotoPersistenceHelper.manager.deletePhoto(specificID: id)
            } catch {}
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    self.allPhotos = try PhotoPersistenceHelper.manager.getPhotos()
                } catch {}
            }
        }
    }
    
    
    private func editPhoto(photoToEdit: Photo){
        let photoToEdit = photoToEdit
        let addPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPhotoVC") as! AddPhotoViewController
        addPhotoVC.currentPhoto = photoToEdit
        addPhotoVC.currentState = .isEditingPhoto
        addPhotoVC.isInDarkmode = self.isInDarkMode
        addPhotoVC.delegate = self
        self.present(addPhotoVC, animated: true, completion: nil)
    }
    
    
    private func loadPhotoJournal(){
        do {
            allPhotos = try PhotoPersistenceHelper.manager.getPhotos()
        } catch {}
    }
    
    
    private func setDarkMode(){
        isInDarkMode = true
        view.backgroundColor = #colorLiteral(red: 0.1113023534, green: 0.1257199049, blue: 0.142811358, alpha: 1)
        [addButton, settingsButton].forEach({$0?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)})
        toolBar.barStyle = .black
        toolBar.barTintColor = #colorLiteral(red: 0.09329102188, green: 0.09929855913, blue: 0.1066427454, alpha: 1)
        
    }
    
    
    private func setLightMode() {
        isInDarkMode = false
        view.backgroundColor = #colorLiteral(red: 0.8974782825, green: 0.7157379985, blue: 0.6262267232, alpha: 1)
        [addButton, settingsButton].forEach({$0?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)})
        toolBar.barStyle = .default
        toolBar.barTintColor = #colorLiteral(red: 0.9895533919, green: 0.6961515546, blue: 0.441628933, alpha: 1)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoJournal()
        loadUserSettings()
        
        for (index, photo) in allPhotos.enumerated() {
            print( "Index:\(index), Name: \(photo.description), ID: \(photo.id.description))")
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allPhotos.count == 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: pictureCollectionView.bounds.size.width, height: pictureCollectionView.bounds.size.height))
            
            noDataLabel.text = "You have no photos added. Tap the + button to get started."
            noDataLabel.numberOfLines = 2
            noDataLabel.textColor = #colorLiteral(red: 0.7722676396, green: 0.7723984122, blue: 0.7722503543, alpha: 0.6343254842)
            noDataLabel.textAlignment = .center
            pictureCollectionView.backgroundView = noDataLabel
        } else {
            pictureCollectionView.backgroundView = nil
        }
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let specificPhoto = allPhotos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PhotoCollectionViewCell
        cell.configureCell(from: specificPhoto)
        cell.buttonFunction = { self.presentActionSheet(id: specificPhoto.id, photo: specificPhoto) }
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 460)
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


extension PhotoViewController: setSettingsDelegate {
    func loadUserSettings() {
        let savedUserTheme = UserDefaultsWrapper.shared.getTheme()
        savedUserTheme == 0 ? setDarkMode() : setLightMode()
        
        let savedUserScrollDirection = UserDefaultsWrapper.shared.getScrollDirection()
        let scrollDirection = savedUserScrollDirection == 0 ? UICollectionView.ScrollDirection.vertical : UICollectionView.ScrollDirection.horizontal
        
        if let collectionViewFlowLayout = pictureCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.scrollDirection = scrollDirection
        }
    }
}
