//
//  SettingsViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/4/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: -- Outlets
    @IBOutlet var settingsLabels: [UILabel]!
    @IBOutlet weak var visualBlurEffect: UIVisualEffectView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var scrollDirectionSegment: UISegmentedControl!
    @IBOutlet weak var themeSegment: UISegmentedControl!
    @IBOutlet weak var profileNameTextField: UITextField!
    
    //MARK: -- Properties
    var delegate: setSettingsDelegate?
    
    var userProfile = Profile(userName: "User", profileImage: (UIImage(named: "defaultProfileIcon")?.jpegData(compressionQuality: 0.5))!)
    
    //MARK: -- IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let username = profileNameTextField.text else { return }
        guard let profileImage = profileImage.image else { return }
        guard let data = profileImage.jpegData(compressionQuality: 0.5) else { return }
        let profile = Profile(userName: username, profileImage: data)
        do {
            try? ProfilePersistenceHelper.manager.save(profile: profile)
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func themeSegmentChanged(_ sender: UISegmentedControl) {
        UserDefaultsWrapper.shared.store(Theme: sender.selectedSegmentIndex)
        setBGTheme()
        delegate?.loadUserSettings()
    }
    
    @IBAction func scrollDirectionSegmentChanged(_ sender: UISegmentedControl) {
        UserDefaultsWrapper.shared.store(scrollDirection: sender.selectedSegmentIndex)
        delegate?.loadUserSettings()
    }
    
    //MARK: -- Methods
    private func setBGTheme() {
        let userSelectedTheme = UserDefaultsWrapper.shared.getTheme()
        
        for labels in settingsLabels {
            labels.textColor = userSelectedTheme == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        visualBlurEffect.effect = userSelectedTheme == 0 ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .systemThinMaterialLight)
        
        bannerImage.image = userSelectedTheme == 0 ? #imageLiteral(resourceName: "darkModeBanner") : #imageLiteral(resourceName: "lightModeBanner")
        
        if profileNameTextField.isFirstResponder == false {
        profileNameTextField.textColor = userSelectedTheme == 0 ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            profileNameTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    private func setUpProfileIcon() {
        profileImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profileIconTapGesture))
        profileImage.addGestureRecognizer(tapGesture)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 4.0
    }
    
    private func setSegmentControlStates(){
        
        guard let userSelectedTheme = UserDefaultsWrapper.shared.getTheme() else { return }
            themeSegment.selectedSegmentIndex = userSelectedTheme
        
        guard let userSelectedScrollDirection = UserDefaultsWrapper.shared.getScrollDirection() else { return }
        scrollDirectionSegment.selectedSegmentIndex = userSelectedScrollDirection
    }
    
    @objc func profileIconTapGesture(){
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func setUserProfileLabelAndImage(){
        profileNameTextField.text = userProfile.userName
        
        if let profileImageData = UIImage(data: userProfile.profileImage) {
            profileImage.image = profileImageData
        }
    }
    
    private func loadUserProfile(){
        do {
            userProfile = try (ProfilePersistenceHelper.manager.getProfile().last ?? userProfile)
        } catch {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBGTheme()
        setSegmentControlStates()
        setUpProfileIcon()
        loadUserProfile()
        setUserProfileLabelAndImage()
        print(userProfile)
        
        
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.profileImage.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.backgroundColor = .clear
        textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.resignFirstResponder()
        
        return true
    }
}
