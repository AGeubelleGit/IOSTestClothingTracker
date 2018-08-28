//
//  ClothingDataHelper.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation
import SQLite

class ClothingDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Clothing"
    
    static let table = Table(TABLE_NAME)
    static let clothingId = Expression<Int64>("clothingId")
    static let type = Expression<String>("type")
    static let name = Expression<String>("name")
    static let imageId = Expression<String>("imageId")
    static let deleted = Expression<Bool>("deleted")
    
    typealias T = ClothingSQL
    
    static func getTable() -> Table {
        return table
    }
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(clothingId, primaryKey: true)
                t.column(type)
                t.column(name)
                t.column(imageId)
                t.column(deleted)
            })
        } catch _ {
            print("Error, table already exists")
            // Error throw if table already exists
        }
        
    }
    
    static func clearTable() throws -> Bool {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            try DB.run(table.drop())
        } catch {
            print("unnable to drop clothing table")
            return false
        }
        do {
            try createTable()
        } catch {
            print("unnable to recreate clothing table")
            return false
        }
        return true
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.clothingId != nil && item.type != nil && item.name != nil && item.imageId != nil && item.deleted != nil) {
            let insert = table.insert(type <- item.type!, name <- item.name!, imageId <- item.imageId!, deleted <- item.deleted!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.clothingId {
            let query = table.filter(clothingId == id)
            do {
                if try DB.run(query.update(deleted <- true)) > 0 {
                    print("deleted")
                } else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func hardDelete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.clothingId {
            let query = table.filter(clothingId == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(clothingId == id)
        let items = try DB.prepare(query)
        for item in  items {
            return ClothingSQL(clothingId: item[clothingId] , type: item[type], name: item[name], imageId: item[imageId], deleted: item[deleted])
        }
        
        return nil
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray: [T] = []
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(ClothingSQL(clothingId: item[clothingId], type: item[type], name: item[name], imageId: item[imageId], deleted: item[deleted]))
        }
        
        return retArray
        
    }
    
    static func findAllByDeleted(isDeleted: Bool) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray: [T] = []
        let query = table.filter(deleted == isDeleted)
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(ClothingSQL(clothingId: item[clothingId], type: item[type], name: item[name], imageId: item[imageId], deleted: item[deleted]))
        }
        
        return retArray
        
    }
}

