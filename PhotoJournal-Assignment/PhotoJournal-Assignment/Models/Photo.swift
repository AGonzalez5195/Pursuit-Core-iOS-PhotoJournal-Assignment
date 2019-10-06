//
//  Picture.swift
//  PhotoJournal-Assignment
//
//  Created by Pursuit on 10/3/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let description: String
    let image: Data
    let id: Int
    
    static func getIDForNewPhoto() -> Int {
        do {
            let photos = try PhotoPersistenceHelper.manager.getPhotos()
            let max = photos.map{$0.id}.max() ?? 0
            return max + 1
        } catch {
            print(error)
        }
       return 0
    }
}


//    static func getPictures()-> [Photo]{
//        return ([Photo(description: "Mr Egghead", imageName: "egghead", id: 0), Photo(description: "Dont Hug Me I'm Scared", imageName: "yellow", id: 1)])
//    }
