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
    
    var closet: [Clothing.ClothingType: [Clothing]]
    //var notLastTwoWeeksCloset: [Clothing.ClothingType: [Clothing]]
    //var closetHistory: [Date: [Clothing]]
    
    private init() {
        self.closet = Closet.initMockData()
    }

    // Get functions
    public func getClothing(sectionNumber: Int, sectionIndex: Int) -> Clothing {
        return self.closet[getDictionaryKeyByInt(index: sectionNumber)]![sectionIndex]
    }
    
    // Collection View Data Source functions
    public func getNumSections() -> Int {
        return self.closet.count
    }
    
    public func getNumClothesInSectionByInt(sectionNumber: Int) -> Int {
        return self.closet[getDictionaryKeyByInt(index: sectionNumber)]!.count;
    }
    
    public func getSectionTitle(index: Int) -> String {
        return getDictionaryKeyByInt(index: index).rawValue
    }
    
    private func getDictionaryKeyByInt(index: Int) -> Clothing.ClothingType {
        return Array(self.closet.keys)[index]
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
}
