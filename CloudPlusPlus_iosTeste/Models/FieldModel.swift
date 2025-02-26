//
//  h.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation

struct FieldModel: Codable, Identifiable {
    // modelo para o arquivo 200-form.json
    var id: String { uuid }
    let type: String
    let label: String
    let name: String
    let required: Bool?
    let uuid: String
    let options: [OptionModel]?
}
