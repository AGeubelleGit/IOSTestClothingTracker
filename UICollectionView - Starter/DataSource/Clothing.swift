//
//  Clothing.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/22/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation

// The Clothing object
class Clothing {
    var name: String?
    var imageId: String?
    var colors: [String]?
    var type: ClothingType?
    
    enum ClothingType: String {
        case shirt = "Shirt"
        case jacket = "Jacket"
        case sweatshirt = "Sweatshirt"
        case shoes = "Shoes"
        case pants = "Pants"
        case shorts = "Shorts"
        case other = "Other"
    }
    
    public init() {
        
    }
    
    public init(name: String, imageId: String, type: ClothingType) {
        self.name = name
        self.imageId = imageId
        self.type = type
    }
}
