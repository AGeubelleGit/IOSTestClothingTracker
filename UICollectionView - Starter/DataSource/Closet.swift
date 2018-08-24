//
//  Closet.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/22/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation

// Contains all the user's clothes
class Closet {
    static var sharedInstance = Closet()
    
    private var closet: [Clothing.ClothingType: [Clothing]]
    //var notLastTwoWeeksCloset: [Clothing.ClothingType: [Clothing]]
    private var closetHistory: [Date: [Clothing]]
    
    private init() {
        self.closet = Closet.initMockData()
        self.closetHistory = Closet.initMockHistory()
    }

    // Closet
    public func getCloset() -> [Clothing.ClothingType: [Clothing]] {
        return self.closet
    }
    
    // History
    public func getHistory() -> [Date: [Clothing]] {
        return self.closetHistory
    }
    
    // Get Data on init
    private static func loadSavedCloset() -> [Clothing.ClothingType: [Clothing]] {
        let savedCloset = [Clothing.ClothingType: [Clothing]]()
        // Load actual saved data.
        return savedCloset
    }
    
    private static func initMockData() -> [Clothing.ClothingType: [Clothing]] {
        var mockCloset = [Clothing.ClothingType: [Clothing]]()
        mockCloset[Clothing.ClothingType.shirt] = [
            Clothing(name: "flannelshirt", imageId: "flannelshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "longshirt", imageId: "longshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "shortshirt", imageId: "shortshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "sportsshirt", imageId: "sportsshirt", type: Clothing.ClothingType.shirt)
        ]
        mockCloset[Clothing.ClothingType.pants] = [
            Clothing(name: "jeans", imageId: "jeans", type: Clothing.ClothingType.pants),
            Clothing(name: "kakhis", imageId: "kakhis", type: Clothing.ClothingType.pants),
            Clothing(name: "sweatpants", imageId: "sweatpants", type: Clothing.ClothingType.pants),
        ]
        
        return mockCloset
    }
    
    private static func initMockHistory() -> [Date: [Clothing]] {
        var mockHistory = [Date: [Clothing]]()
        mockHistory[Date.init(timeIntervalSince1970: 1534999905)] = [
            Clothing(name: "flannelshirt", imageId: "flannelshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "jeans", imageId: "jeans", type: Clothing.ClothingType.pants)
        ]
        mockHistory[Date.init(timeIntervalSince1970: 1534852800)] = [
            Clothing(name: "kakhis", imageId: "kakhis", type: Clothing.ClothingType.pants),
            Clothing(name: "flannelshirt", imageId: "flannelshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "longshirt", imageId: "longshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "shortshirt", imageId: "shortshirt", type: Clothing.ClothingType.shirt),
            Clothing(name: "sportsshirt", imageId: "sportsshirt", type: Clothing.ClothingType.shirt)
        ]
        mockHistory[Date.init(timeIntervalSince1970: 1534552800)] = [
            Clothing(name: "sweatpants", imageId: "sweatpants", type: Clothing.ClothingType.pants),
            Clothing(name: "sportsshirt", imageId: "sportsshirt", type: Clothing.ClothingType.shirt)
        ]
        
        return mockHistory
    }
}
