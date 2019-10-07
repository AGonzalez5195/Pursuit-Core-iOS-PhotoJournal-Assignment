//
//  UserDefaultsWrapper.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/6/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

class UserDefaultsWrapper {
    
    static let shared = UserDefaultsWrapper()
    
    private let themeKey = "themeKey"
    
    func store(Theme: Int) { UserDefaults.standard.set(Theme, forKey: themeKey) }
    
    func getTheme() -> Int? { return UserDefaults.standard.value(forKey: themeKey) as? Int }
 
}
