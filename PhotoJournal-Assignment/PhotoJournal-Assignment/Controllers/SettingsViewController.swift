//
//  SettingsViewController.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/4/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var visualBlurEffect: UIVisualEffectView!
    @IBOutlet var settingsLabels: [UILabel]!
    @IBOutlet weak var scrollDirectionSegment: UISegmentedControl!
    @IBOutlet weak var themeSegment: UISegmentedControl!
    
    var delegate: setSettingsDelegate?
    
    @IBAction func themeSegmentChanged(_ sender: UISegmentedControl) {
        UserDefaultsWrapper.shared.store(Theme: sender.selectedSegmentIndex)
        setBGTheme()
        delegate?.loadUserSettings()
    }
    
    @IBAction func scrollDirectionSegmentChanged(_ sender: UISegmentedControl) {
        UserDefaultsWrapper.shared.store(scrollDirection: sender.selectedSegmentIndex)
        delegate?.loadUserSettings()
    }
    
    private func setBGTheme() {
        let userSelectedTheme = UserDefaultsWrapper.shared.getTheme()
        
        for labels in settingsLabels {
            labels.textColor = userSelectedTheme == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        visualBlurEffect.effect = userSelectedTheme == 0 ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .extraLight)
        
        bannerImage.image = userSelectedTheme == 0 ? #imageLiteral(resourceName: "darkModeBanner") : #imageLiteral(resourceName: "lightModeBanner")
    }
    
    private func setCircleOutline() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 4.0
    }
    
    private func setSegmentControlStates(){
        let userSelectedTheme = UserDefaultsWrapper.shared.getTheme()
        themeSegment.selectedSegmentIndex = userSelectedTheme!
        
        guard let userSelectedScrollDirection = UserDefaultsWrapper.shared.getScrollDirection() else { return }
        scrollDirectionSegment.selectedSegmentIndex = userSelectedScrollDirection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBGTheme()
        setSegmentControlStates()
        setCircleOutline()
    }
}
