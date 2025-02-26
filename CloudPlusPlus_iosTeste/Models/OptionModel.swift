//
//  h.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation

struct OptionModel: Codable, Identifiable {
    var id: String { value }
    let label: String
    let value: String
}
