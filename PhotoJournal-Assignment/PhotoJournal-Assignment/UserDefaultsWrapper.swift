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
    private let scrollDirectionKey = "scrollDirectionKey"
    
    func store(Theme: Int) { UserDefaults.standard.set(Theme, forKey: themeKey) }
    
    func store(scrollDirection: Int) { UserDefaults.standard.set(scrollDirection, forKey: scrollDirectionKey) }
    
    func getTheme() -> Int? { return UserDefaults.standard.value(forKey: themeKey) as? Int }
    
    func getScrollDirection() -> Int? { return UserDefaults.standard.value(forKey: scrollDirectionKey) as? Int }
 
}
