//
//  ClothingHistoryDTO.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/26/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

class ClothingHistory {
    var id: Int64!
    var date: Date!
    var clothingNames: [String]!
    var clothingImageIds: [String]!
    var numClothingItems: Int64!
    
    init(id: Int64, date: Date, clothingNames: [String], clothingImageIds: [String], numClothingItems: Int64) {
        self.id = id
        self.date = date
        self.clothingNames = clothingNames
        self.clothingImageIds = clothingImageIds
        self.numClothingItems = numClothingItems
    }
    
    func toString() -> String {
        return "id: \(self.id) " +
        "\ndate: \(self.date) " +
        "\nclothingNames: \(self.clothingNames)" +
        "\nclothingImageIds: \(self.clothingImageIds)" +
        "\nnumClothingItems: \(self.numClothingItems)"
    }
}
