//
//  ClothingDTO.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/26/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

class Clothing {
    var id: Int64?
    var type: ClothingType!
    var name: String!
    var imageId: String!
    
    init(id: Int64, type: ClothingType, name: String, imageId: String) {
        self.id = id
        self.type = type
        self.name = name
        self.imageId = imageId
    }
    
    init(clothingSQL: ClothingSQL) {
        self.id = clothingSQL.clothingId
        self.type = ClothingType(rawValue: clothingSQL.type)!
        self.name = clothingSQL.name
        self.imageId = clothingSQL.imageId
    }
    
    func toString() -> String {
        return "id: \(self.id) " +
            "\ndname: \(self.name) " +
            "\ntype: \(self.type.rawValue)" +
            "\nimageId: \(self.imageId)"
    }
}
