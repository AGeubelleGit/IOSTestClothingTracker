//
//  ClothingObject.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

class ClothingSQL {
    var clothingId: Int64!
    var type: String!
    var name: String!
    var imageId: String!
    var deleted: Bool!
    
    init() {
        clothingId = 0
    }
    
    init(clothingId: Int64?) {
        self.clothingId = clothingId
    }
    
    init(clothingId: Int64?, type: ClothingType?, name: String?, imageId: String?, deleted: Bool?) {
        self.clothingId = clothingId
        self.type = type?.rawValue
        self.name = name
        self.imageId = imageId
        self.deleted = deleted
    }
    
    init(clothingId: Int64?, type: String?, name: String?, imageId: String?, deleted: Bool?) {
        self.clothingId = clothingId
        self.type = type
        self.name = name
        self.imageId = imageId
        self.deleted = deleted
    }
    
    static func insertFromClothingObject(clothing: Clothing) -> ClothingSQL {
        let clothingObject = ClothingSQL()
        clothingObject.clothingId = 0
        clothingObject.type = clothing.type.rawValue
        clothingObject.name = clothing.name
        clothingObject.imageId = clothing.imageId
        clothingObject.deleted = false
        return clothingObject
    }
    
    
}
