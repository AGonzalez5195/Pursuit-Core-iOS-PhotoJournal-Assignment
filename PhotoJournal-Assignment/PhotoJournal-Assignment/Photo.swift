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
    let imageName: String
    let id: Int
    
    
    static func getPictures()-> [Photo]{
        return ([Photo(description: "eat my ass", imageName: "egghead", id: 0), Photo(description: "eat his ass too", imageName: "yellow", id: 1)])
    }
}
