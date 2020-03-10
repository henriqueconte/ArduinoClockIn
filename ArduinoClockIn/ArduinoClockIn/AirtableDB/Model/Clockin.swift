//
//  Clockin.swift
//  ArduinoClockIn
//
//  Created by Pedro Lopes on 09/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import SwiftAirtable

struct Clockin {
    var id: String = ""
    var time: Date = Date()
    var isClockOut: Bool = false
    var owner: String = ""
}

extension Clockin: AirtableObject {
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        var fields = [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)]()
        fields.append((fieldName: "time", fieldType: .dateWithHour))
        fields.append((fieldName: "isClockOut", fieldType: .checkbox))
        fields.append((fieldName: "owner", fieldType: .singleLineText))
        return fields
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: "time", fieldType: .dateWithHour): return self.time
        case AirtableTableSchemaFieldKey(fieldName: "isClockOut", fieldType: .checkbox): return self.isClockOut
        case AirtableTableSchemaFieldKey(fieldName: "owner", fieldType: .singleLineText): return self.owner
        default: return nil
        }
    }
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        tableSchemaKeys.forEach { element in
            switch element.key {
            case AirtableTableSchemaFieldKey(fieldName: "time", fieldType: .singleLineText): self.time = element.value.dateValue
            case AirtableTableSchemaFieldKey(fieldName: "isClockOut", fieldType: .singleLineText): self.isClockOut = element.value.boolValue
            case AirtableTableSchemaFieldKey(fieldName: "owner", fieldType: .singleLineText): self.owner = element.value.stringValue
            default: break
            }
        }
    }
}
