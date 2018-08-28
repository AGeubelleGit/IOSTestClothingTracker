//
//  SQLiteDataStore.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation
import SQLite

//http://masteringswift.blogspot.com/2015/09/create-data-access-layer-with.html
class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        var path = "ClothingDB.sqlite"
        let pathStr = "ClothingDB.sqlite"
        
        if let dirs: [NSString] =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [NSString] {
            let dir = dirs[0]
            path = dir.appendingPathComponent(pathStr);
        }
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
    
    static func clearTables(clothing: Bool, history: Bool) -> Void {
        if clothing {
            do {
                let success = try ClothingDataHelper.clearTable()
                if success {
                    print("Cleared Clothing Table")
                } else {
                    print("Unable to clear clothing table")
                }
            } catch {
                print("Error in clearning clothing table \(error)")
            }
        }
        if history {
            do {
                let success = try ClothingHistoryHelper.clearTable()
                if success {
                    print("Cleared Clothing History Table")
                } else {
                    print("Unable to clear clothing history table")
                }
            } catch {
                print("Error in clearning clothing history table \(error)")
            }
        }
    }
    
    static func createTables(clothes: Bool, history: Bool) {
        if clothes {
            // Create Clothes table
            do {
                try ClothingDataHelper.createTable()
                print("Created Clothes Table")
            } catch {
                print("Error in creating table \(error)")
            }
        }
        if history {
            // Create Clothes History table
            do {
                try ClothingHistoryHelper.createTable()
                print("Created Clothing History Table")
            } catch {
                print("Error in creating table \(error)")
            }
        }
    }
    
    static func clothesInsertMockData(clothes: Bool, history: Bool) {
        if clothes {
            let names: [String] = ["shortshirt", "longshirt", "flannelshirt", "sportsshirt", "jeans", "kakhis", "sweatpants", "t-shirt"]
            let imageIds: [String] = ["shortshirt", "longshirt", "flannelshirt", "sportsshirt", "jeans", "kakhis", "sweatpants", "Tshirt"]
            let types: [ClothingType] = [ClothingType.shirt, ClothingType.shirt, ClothingType.shirt, ClothingType.shirt, ClothingType.pants, ClothingType.pants, ClothingType.pants, ClothingType.shirt]
            
            do {
                for i in 0 ..< names.count {
                    let insertedClothingObject = try ClothingService.insert(clothing: Clothing(id: 0, type: types[i], name: names[i], imageId: imageIds[i]))
                    print("id: \(insertedClothingObject.id) name: \(insertedClothingObject.name)")
                }
            } catch {
                print("Error on insert")
                print(error)
            }
        }
        if history {
            var mockData: [Date: [Int64]] = [Date: [Int64]]()
            mockData[Date(timeIntervalSince1970: 123456000)] = [1,2,3]
            mockData[Date(timeIntervalSince1970: 133346000)] = [2,4]
            mockData[Date(timeIntervalSince1970: 143346000)] = [5,8]
            
            do {
                for date in mockData.keys {
                    let insertedIds: [Int64] = try ClothingHistoryService.addClothingSetToHistory(date: date, clothingIds: mockData[date]!)
                    print("inserted \(insertedIds)")
                }
            } catch {
                print("Error on insert")
                print(error)
            }
        }
    }
    
    static func printAll(clothes: Bool, history: Bool) {
        if clothes {
            print("All Clothes")
            do {
                if let clothes = try ClothingDataHelper.findAll() {
                    for clothingItem in clothes {
                        print("id \(clothingItem.clothingId!) name:\(clothingItem.name!)" +
                            " imageId \(clothingItem.imageId!) deleted:\(clothingItem.deleted!)")
                    }
                }
            } catch {
                print("Error in find all of clothing \(error)")
            }
        }
        
        if history {
            print("Clothing History")
            do {
                if let clothes = try ClothingHistoryHelper.findAll() {
                    for clothingItem in clothes {
                        print("id \(clothingItem.rowId!) clothingHistoryId:\(clothingItem.clothingHistoryId!)" +
                            " clothingId \(clothingItem.clothingId!) date:\(clothingItem.date!) deleted:\(clothingItem.deleted!)")
                    }
                }
            } catch {
                print("Error in find all of clothing history \(error)")
            }
        }
    }
    
    static func getHistoryTest(run: Bool) {
        if run {
            print("Joining Tables")
            do {
                let clothingHistory: [ClothingHistory] = try ClothingHistoryService.getHistory(limit: 10)
                for clothingHistoryObject: ClothingHistory in clothingHistory {
                    print(clothingHistoryObject.toString())
                }
            } catch {
                print("Error in getting history")
            }
        }
    }
    
    static func getClothesDictionaryTest(run: Bool) {
        if run {
            print("Getting Dictionary of Clothes")
            do {
                let clothingDictionary: [ClothingType: [Clothing]] = try ClothingService.getClothesDictionary()
                for key: ClothingType in clothingDictionary.keys {
                    print("----- " + key.rawValue + " -----")
                    for clothingObject: Clothing in clothingDictionary[key]! {
                        print(clothingObject.toString())
                        print("")
                    }
                }
            } catch {
                print("Error in getting clothing dictionary")
            }
        }
    }
}

