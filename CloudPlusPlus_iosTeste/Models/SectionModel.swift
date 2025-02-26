//
//  h.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation

struct SectionModel: Codable, Identifiable {
    var id: String { uuid }
    let title: String
    let from: Int
    let to: Int
    let index: Int
    let uuid: String
}
