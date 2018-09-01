//
//  ClothingService.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/26/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation
import SQLite
import UIKit

class ClothingService {
    
    static func insert(clothing: Clothing) throws -> Clothing {
        let insertedRowId = try ClothingDataHelper.insert(item: ClothingSQL.insertFromClothingObject(clothing: clothing))
        clothing.id = insertedRowId
        return clothing
    }
    
    /*
     Get all clothes that have not been deleted and return in dictionary
    */
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
    
    
    static func addExtraEmptySections(inputDict: [ClothingType: [Clothing]], types: [ClothingType]) -> [ClothingType: [Clothing]] {
        var outputDict = inputDict
        for type: ClothingType in types {
            if outputDict[type] == nil {
                outputDict[type] = [Clothing]()
            }
        }
        return outputDict
    }
    
    /*
     Get all clothes that have not been deleted and not worn in last (limit) number of days
    */
    static func getNotRecentlyWornClothes(filterTypes: [String], allTypes: [ClothingType], limit: Int) throws -> [ClothingType: [Clothing]] {
        let statement: Statement
        do {
            var arrayAsString: String = filterTypes.description
            arrayAsString = arrayAsString.replacingOccurrences(of: "[", with: "")
            arrayAsString = arrayAsString.replacingOccurrences(of: "]", with: "")
            // select all clothes whose ids are not in the last <limit> day history.
            let statementStringTest = "SELECT * " +
                "FROM Clothing " +
                "WHERE deleted=0 AND " +
                "(Clothing.type NOT IN (" + arrayAsString + ") " +
            "OR Clothing.clothingId NOT IN " +
            "(SELECT ClothingHistory.ClothingId " +
            "FROM ClothingHistory " +
            "WHERE julianday('now') - julianday(ClothingHistory.date) < (?)));"
            statement = try ClothingDataHelper.runStatement(statement: statementStringTest, bindings: limit)
        } catch {
            print("Error in getting clothes from SQL database \(error)")
            return [ClothingType: [Clothing]]()
        }
        
        let indexes: [String: Int]
        do {
            indexes = try getIndexesForClothingObject(statement: statement)
        } catch {
            print("error in getting indexes")
            return [ClothingType: [Clothing]]()
        }
        
        var clothingDictionary =  [ClothingType: [Clothing]]()
        for row in statement {
            let id: Int64 = row[indexes["id"]!] as! Int64
            let typeStr: String = row[indexes["type"]!] as! String
            let type: ClothingType = ClothingType(rawValue: typeStr)!
            let name: String = row[indexes["name"]!] as! String
            let imageId: String = row[indexes["imageId"]!] as! String
            
            let clothingObject: Clothing = Clothing(id: id, type: type, name: name, imageId: imageId)
            if clothingDictionary[type] == nil {
                clothingDictionary[type] = [clothingObject]
            } else {
                clothingDictionary[type]!.append(clothingObject)
            }
        }
        
        return addExtraEmptySections(inputDict: clothingDictionary, types: allTypes)
    }
    
    /*
     Takes a statement for list of clothingSQL objects and creates indexes dictionary
    */
    private static func getIndexesForClothingObject(statement: Statement) throws -> [String: Int] {
        var indexes = [String: Int]()
        indexes["id"] = statement.columnNames.index(of: "clothingId")!
        indexes["type"] = statement.columnNames.index(of: "type")!
        indexes["name"] = statement.columnNames.index(of: "name")!
        indexes["imageId"] = statement.columnNames.index(of: "imageId")!
        return indexes
    }
    
    static func addClothingRow(clothingType: ClothingType, name: String, image: UIImage) throws -> Clothing {
        let uniqueImageName = name + "-" + NSUUID().uuidString.lowercased()
        ImageUtils.saveImage(image: image, imageName: uniqueImageName)
        let clothingObject: Clothing = Clothing(id: 0, type: clothingType, name: name, imageId: uniqueImageName)
        return try ClothingService.insert(clothing: clothingObject)
    }
}
