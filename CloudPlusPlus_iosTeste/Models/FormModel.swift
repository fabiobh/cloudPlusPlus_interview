//
//  h.swift
//  CloudPlusPlus_iosTeste
//
//  Created by FabioCunha on 23/02/25.
//

import Foundation

struct FormModel: Identifiable, Codable {
    var id: String { uuid }
    let title: String
    let fields: [FieldModel]
    let sections: [SectionModel]
    let uuid: String // uso do UUID como identificação

    enum CodingKeys: String, CodingKey {
        case title, fields, sections, uuid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.fields = try container.decode([FieldModel].self, forKey: .fields)
        self.sections = try container.decode([SectionModel].self, forKey: .sections)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? UUID().uuidString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(fields, forKey: .fields)
        try container.encode(sections, forKey: .sections)
        try container.encode(uuid, forKey: .uuid)
    }
}


