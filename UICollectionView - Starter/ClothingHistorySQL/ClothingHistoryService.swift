//
//  ClothingHistoryService.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/26/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation
import SQLite

class ClothingHistoryService {
    static func getHistory(limit: Int64) throws -> [ClothingHistory] {
        let getHistoryStatement: Statement
        do {
            let selectHistorySQLStatement = """
            select
            ClothingHistory.clothingHistoryId as clothingHistoryId,
            ClothingHistory.date as date,
            group_concat(Clothing.name) as names,
            group_concat(Clothing.imageId) as imageIds,
            Count(*) as count
            from ClothingHistory join Clothing on ClothingHistory.clothingId == Clothing.clothingId
            where ClothingHistory.deleted=0 and Clothing.deleted=0
            group by ClothingHistory.clothingHistoryId, ClothingHistory.date
            order by ClothingHistory.date desc
            limit (?);
            """
            getHistoryStatement = try ClothingHistoryHelper.runStatement(statement: selectHistorySQLStatement, bindings: limit)
        } catch {
            print("Error in getting history from SQL database \(error)")
            return [ClothingHistory]()
        }
        
        let indexes: [String: Int]
        do {
            indexes = try getHistoryIndexes(historyStatement: getHistoryStatement)
        } catch {
            print("error in getting indexes")
            return [ClothingHistory]()
        }
        
        var historyDTOs: [ClothingHistory] = [ClothingHistory]()
        
        let dateFormatter = DateFormatter() // from 1974-03-24T08:33:20.000
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        for row in getHistoryStatement {
            let numClothingItems: Int64 = row[indexes["count"]!] as! Int64
            let id: Int64 = row[indexes["id"]!] as! Int64
            let date: Date = dateFormatter.date(from: row[indexes["date"]!] as! String)!
            let clothingNamesStr = row[indexes["names"]!] as! String
            let clothingNames: [String] = clothingNamesStr.components(separatedBy: ",")
            let clothingImageIdsString = row[indexes["imageIds"]!] as! String
            let clothingImageIds: [String] = clothingImageIdsString.components(separatedBy: ",")
            let dto: ClothingHistory = ClothingHistory(id: id, date: date, clothingNames: clothingNames, clothingImageIds: clothingImageIds, numClothingItems: numClothingItems)
            historyDTOs.append(dto)
        }

        return historyDTOs
    }
    
    private static func getHistoryIndexes(historyStatement: Statement) throws -> [String: Int] {
        var indexes = [String: Int]()
        indexes["id"] = historyStatement.columnNames.index(of: "clothingHistoryId")!
        indexes["date"] = historyStatement.columnNames.index(of: "date")!
        indexes["names"] = historyStatement.columnNames.index(of: "names")!
        indexes["imageIds"] = historyStatement.columnNames.index(of: "imageIds")!
        indexes["count"] = historyStatement.columnNames.index(of: "count")!
        return indexes
    }
    
    static func addClothingSetToHistory(date: Date, clothingIds: [Int64]) throws -> [Int64] {
        var createdRowIds = [Int64]()
        let nextRowId: Int64!
        do {
            // Create dummy row to get next id that will serve as clothingHistoryId
            nextRowId = try ClothingHistoryHelper.insert(item: ClothingHistorySQL(rowId: 0, clothingHistoryId: 0, clothingId: 0, date: Date(timeIntervalSince1970: 0), deleted: true))
        } catch {
            print("Error in creating dummy row")
            return createdRowIds
        }
        let newHistoryRows = ClothingHistorySQL.insertConstructor(date: date, clothingHistoryId: nextRowId, clothingIds: clothingIds)
        do {
            var isFirst: Bool = true
            for newHistoryRow: ClothingHistorySQL in newHistoryRows {
                if isFirst {
                    newHistoryRow.rowId = nextRowId
                    try ClothingHistoryHelper.update(item: newHistoryRow)
                    createdRowIds.append(nextRowId)
                    isFirst = false
                } else {
                    try createdRowIds.append(ClothingHistoryHelper.insert(item: newHistoryRow))
                }
            }
        } catch {
            print("Error in adding rows")
            return [Int64]()
        }
        return createdRowIds
    }
    
    static func deleteHistoryRow(historyObject: ClothingHistory) throws -> Void {
        let currHistoryRows: [ClothingHistorySQL] = (try ClothingHistoryHelper.findAllByHistoryId(historyId: historyObject.id))!
        for row: ClothingHistorySQL in currHistoryRows {
            try ClothingHistoryHelper.delete(item: row)
        }
    }
}
