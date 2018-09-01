//
//  ClothingDataHelper.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation
import SQLite

class ClothingHistoryHelper: DataHelperProtocol {
    static let TABLE_NAME = "ClothingHistory"
    
    static let table = Table(TABLE_NAME)
    static let rowId = Expression<Int64>("rowId")
    static let clothingHistoryId = Expression<Int64>("clothingHistoryId")
    static let clothingId = Expression<Int64>("clothingId")
    static let date = Expression<Date>("date")
    static let deleted = Expression<Bool>("deleted")
    
    typealias T = ClothingHistorySQL
    
    static func getTable() -> Table {
        return table
    }
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(rowId, primaryKey: true)
                t.column(clothingHistoryId)
                t.column(clothingId)
                t.column(date)
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
            print("unnable to drop history table")
            return false
        }
        do {
            try createTable()
        } catch {
            print("unnable to recreate history table")
            return false
        }
        return true
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.rowId != nil && item.clothingHistoryId != nil && item.clothingId != nil && item.date != nil && item.deleted != nil) {
            let insert = table.insert(clothingHistoryId <- item.clothingHistoryId!, clothingId <- item.clothingId!, date <- item.date!, deleted <- item.deleted!)
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
    
    static func update (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.rowId {
            let query = table.filter(rowId == id)
            do {
                if try DB.run(query.update(clothingHistoryId <- item.clothingHistoryId!,
                                           clothingId <- item.clothingId!,
                                           date <- item.date!,
                                           deleted <- item.deleted!)) > 0 {
                    print("updated")
                } else {
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.rowId {
            let query = table.filter(rowId == id)
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
        if let id = item.rowId {
            let query = table.filter(rowId == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.Delete_Error
                }
                print("Hard Deleted")
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func find(id: Int64) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(rowId == id)
        let items = try DB.prepare(query)
        for item in  items {
            return ClothingHistorySQL(rowId: item[rowId] , clothingHistoryId: item[clothingHistoryId], clothingId: item[clothingId], date: item[date], deleted: item[deleted])
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
            retArray.append(ClothingHistorySQL(rowId: item[rowId], clothingHistoryId: item[clothingHistoryId], clothingId: item[clothingId], date: item[date], deleted: item[deleted]))
        }
        
        return retArray
    }
    
    static func findAllByHistoryId(historyId: Int64) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray: [T] = []
        let query = table.filter(clothingHistoryId == historyId)
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(ClothingHistorySQL(rowId: item[rowId], clothingHistoryId: item[clothingHistoryId], clothingId: item[clothingId], date: item[date], deleted: item[deleted]))
        }
        
        return retArray
    }
    
    static func runStatement(statement: String, bindings: Binding ...) throws -> Statement {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        return try DB.run(statement, bindings)
    }
}

