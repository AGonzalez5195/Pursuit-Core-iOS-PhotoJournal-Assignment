//
//  PhotoPersistenceHelper.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct PhotoPersistenceHelper {
    static let manager = PhotoPersistenceHelper()
    
    func save(newPhoto: Photo) throws {
        try persistenceHelper.save(newElement: newPhoto)
    }
    
    func getPhotos() throws -> [Photo] {
        return try persistenceHelper.getObjects()
    }
    
    func deletePhoto(withID: Int) throws {
        do {
            let photos = try getPhotos()
            let newPhotos = photos.filter { $0.id != withID}
            try persistenceHelper.replace(elements: newPhotos)
        }
    }
    //Makes a new array that copies the original array in every way other than that it excludes the favorite with the specific ID.
    
    private let persistenceHelper = PersistenceHelper<Photo>(fileName: "photosss.plist")
    
    private init() {}
}
