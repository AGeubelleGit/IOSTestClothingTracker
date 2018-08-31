//
//  ClothingTypes.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/27/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//
// Alexandre Geubelle

import Foundation

enum ClothingType: String {
    case shirt = "Shirt"
    case jacket = "Jacket"
    case sweatshirt = "Sweatshirt"
    case shoes = "Shoes"
    case pants = "Pants"
    case shorts = "Shorts"
    case other = "Other"
    
    static func getAll() -> [ClothingType] {
        return [ClothingType.shirt, ClothingType.sweatshirt, ClothingType.jacket, ClothingType.pants, ClothingType.shorts, ClothingType.shoes, ClothingType.other]
    }
}
