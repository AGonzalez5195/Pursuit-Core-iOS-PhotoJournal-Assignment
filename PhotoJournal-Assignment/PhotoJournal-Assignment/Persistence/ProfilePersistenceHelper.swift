//
//  ProfilePersistenceHelper.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/7/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct ProfilePersistenceHelper {
    private init() {}
    private let persistenceHelper = PersistenceHelper<Profile>(fileName: "userProfiles.plist")
    
    static let manager = ProfilePersistenceHelper()
    
    func save(profile: Profile) throws {
        try persistenceHelper.save(newElement: profile)
    }
    
    func getProfile() throws -> [Profile] {
        return try persistenceHelper.getObjects()
    }
}
