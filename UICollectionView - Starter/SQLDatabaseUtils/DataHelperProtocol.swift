//
//  DataHelperProtocol.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}
