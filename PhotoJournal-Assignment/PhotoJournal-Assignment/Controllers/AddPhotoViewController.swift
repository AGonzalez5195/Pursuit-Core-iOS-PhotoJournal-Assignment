//
//  AddPhotoViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import Photos

class AddPhotoViewController: UIViewController {
    //MARK: -- Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var visualBlurEffect: UIVisualEffectView!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //MARK: -- Properties
    var delegate: loadUserDataDelegate?
    var currentPhoto: Photo!
    var currentState: AddOrEdit = .isAddingPhoto
    var photoLibraryAccess = false
    var isInDarkmode = Bool()
    
    //MARK: --IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIBarButtonItem) {
        if photoLibraryAccess == true {
            presentImagePicker()
        } else {
            checkPhotoLibraryAccess()
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveEntry()
    }
    //MARK: -- Methods
    private func saveEntry(){
        guard let text = descriptionTextView.text else { return }
        guard let image = image.image else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let photo = Photo(description: text, image: data, date: Photo.getTimeStamp(), id: Photo.getIDForNewPhoto())
        do {
            switch currentState {
            case .isAddingPhoto:
                try? PhotoPersistenceHelper.manager.save(newPhoto: photo)
                delegate?.loadUserJournal()
                
            case .isEditingPhoto:
                try? PhotoPersistenceHelper.manager.overwritePhoto(photo: photo, id: currentPhoto.id)
                delegate?.loadUserJournal()
            }
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            presentImagePicker()
            
        case .denied:
            let alertVC = UIAlertController(title: "Denied", message: "Photo Library access is required to use this app. Please change your preference in the Settings app", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction (title: "Ok", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .authorized:
                    self.photoLibraryAccess = true
                    print(status)
                case .denied:
                    self.photoLibraryAccess = false
                    print("denied")
                case .notDetermined:
                    print("not determined")
                case .restricted:
                    print("restricted")
                }
            })
        }
    }
    
    
    private func presentImagePicker(){
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    private func setUpView(){
        image.layer.cornerRadius = 40
        if currentState == .isEditingPhoto {
            image.image = UIImage(data: currentPhoto.image)
            descriptionTextView.text = currentPhoto.description
            descriptionTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            image.image = #imageLiteral(resourceName: "addPhoto")
            descriptionTextView.text = "Enter photo description..."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    
    private func setDarkMode(){
        [photoLibraryButton, cameraButton].forEach({ $0?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) })
        toolBar.barStyle = .black
        toolBar.barTintColor = #colorLiteral(red: 0.09329102188, green: 0.09929855913, blue: 0.1066427454, alpha: 1)
        visualBlurEffect.effect = UIBlurEffect(style: .dark)
        let textColor = currentState == .isEditingPhoto ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : .lightGray
        descriptionTextView.textColor = textColor
    }
    
    
    private func setLightMode(){
        [photoLibraryButton, cameraButton].forEach({ $0?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) })
        descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolBar.barStyle = .default
        toolBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        visualBlurEffect.effect = UIBlurEffect(style: .extraLight)
        let textColor = currentState == .isEditingPhoto ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .lightGray
        descriptionTextView.textColor = textColor
    }
    
    
    private func checkUserSelectedTheme(){
        isInDarkmode == true ? setDarkMode() : setLightMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        checkUserSelectedTheme()
    }
}

//MARK: -- Extensions
extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.image.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension AddPhotoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}


