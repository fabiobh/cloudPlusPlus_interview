//
//  g.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation

struct FormEntry: Identifiable, Codable {
    var id: Int64
    var formUUID: String
    var answersJSON: String  // armazenado como um dicionario JSON [String:String]
}
