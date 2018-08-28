//
//  ClothingHistoryObject.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

class ClothingHistorySQL {
    var rowId: Int64?
    var clothingHistoryId: Int64?
    var clothingId: Int64?
    var date: Date?
    var deleted: Bool?
    
    init() {
        clothingId = 0
    }
    
    init(id: Int64?) {
        self.rowId = id
    }
    
    init(rowId: Int64?, clothingHistoryId: Int64?, clothingId: Int64?, date: Date?, deleted: Bool) {
        self.rowId = rowId
        self.clothingHistoryId = clothingHistoryId
        self.clothingId = clothingId
        self.date = date
        self.deleted = deleted
    }
    
    static func insertConstructor(date: Date?, clothingHistoryId: Int64?, clothingIds: [Int64]?) -> [ClothingHistorySQL] {
        var clothingHistoryArray = [ClothingHistorySQL]()
        if clothingIds != nil {
            for clothingId: Int64 in clothingIds! {
                clothingHistoryArray.append(ClothingHistorySQL(rowId: 0, clothingHistoryId: clothingHistoryId,
                                                            clothingId: clothingId, date: date, deleted: false))
            }
        }
        return clothingHistoryArray
    }
}
