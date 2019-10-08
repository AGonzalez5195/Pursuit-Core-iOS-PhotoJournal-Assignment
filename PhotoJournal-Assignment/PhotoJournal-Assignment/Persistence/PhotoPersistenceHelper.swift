//
//  PhotoPersistenceHelper.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct PhotoPersistenceHelper {
    private init() {}
    private let persistenceHelper = PersistenceHelper<Photo>(fileName: "photoJournals.plist")

    static let manager = PhotoPersistenceHelper()
    
    func save(newPhoto: Photo) throws {
        try persistenceHelper.save(newElement: newPhoto)
    }
    
    func getPhotos() throws -> [Photo] {
        return try persistenceHelper.getObjects()
    }
    
    func deletePhoto(specificID: Int) throws {
        do {
            let photos = try getPhotos()
            let newPhotos = photos.filter { $0.id != specificID}
            try persistenceHelper.replace(elements: newPhotos)
        }
    }
    
    func overwritePhoto(photo: Photo, id: Int) throws {
        let photos = try getPhotos()
        var oldIndex = Int()
        //get original photo index
        for (index, photo) in photos.enumerated() {
            if photo.id == id {
                oldIndex = index
            }
        }
        try persistenceHelper.saveAtIndex(newElement: photo, indexToSaveAt: oldIndex)
        try deletePhoto(specificID: id)
        
    }
}
