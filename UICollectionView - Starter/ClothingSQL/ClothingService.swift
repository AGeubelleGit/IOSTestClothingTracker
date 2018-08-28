//
//  ClothingService.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/26/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

class ClothingService {
    
    static func insert(clothing: Clothing) throws -> Clothing {
        let insertedRowId = try ClothingDataHelper.insert(item: ClothingSQL.insertFromClothingObject(clothing: clothing))
        clothing.id = insertedRowId
        return clothing
    }
    
    static func getClothesDictionary() throws -> [ClothingType: [Clothing]] {
        let clothesInSQL: [ClothingSQL] = (try ClothingDataHelper.findAllByDeleted(isDeleted: false))!
        var clothingDictionary =  [ClothingType: [Clothing]]()
        for clothingSQLItem in clothesInSQL {
            let clothingType: ClothingType! = ClothingType(rawValue: clothingSQLItem.type!)!
            let clothingObject: Clothing = Clothing(clothingSQL: clothingSQLItem)
            if clothingDictionary[clothingType] == nil {
                clothingDictionary[clothingType] = [clothingObject]
            } else {
                clothingDictionary[clothingType]!.append(clothingObject)
            }
        }
        return clothingDictionary
    }
}
