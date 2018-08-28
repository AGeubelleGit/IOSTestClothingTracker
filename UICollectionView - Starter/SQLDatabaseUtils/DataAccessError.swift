//
//  DataAccessError.swift
//  TestSQL
//
//  Created by Alexandre Geubelle on 8/25/18.
//  Copyright © 2018 Alexandre Geubelle. All rights reserved.
//

import Foundation

enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}
