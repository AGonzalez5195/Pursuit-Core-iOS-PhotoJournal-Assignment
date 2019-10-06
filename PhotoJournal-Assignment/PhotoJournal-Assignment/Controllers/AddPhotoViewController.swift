//
//  AddPhotoViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit



class AddPhotoViewController: UIViewController {
    //MARK: -- Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: -- Properties
    var delegate : loadUserDataDelegate?
    
    //MARK: --IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIBarButtonItem) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let text = descriptionTextView.text else {return}
        guard let image = image.image else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        
        
        let newPhoto = Photo(description: text, image: data, id: Photo.getIDForNewPhoto())
        do {
            try? PhotoPersistenceHelper.manager.save(newPhoto: newPhoto)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        if let parent = delegate {
            parent.loadUserJournal()
        }
    }
    
    private func setTextViewPlaceholder(){    descriptionTextView.text = "Enter photo description..."
        descriptionTextView.textColor = UIColor.lightGray
    }
    
    //MARK: -- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewPlaceholder()
    }
}

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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter photo description..."
            textView.textColor = UIColor.lightGray
        }
    }
}


