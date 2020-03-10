//
//  AirtableClockinDB.swift
//  ArduinoClockIn
//
//  Created by Pedro Lopes on 09/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import SwiftAirtable

class AirtableClockinDB {
    let apiKey = "keyHOVouGJpK0Dde2"
    let apiBaseUrl = "https://api.airtable.com/v0/app0ZyNNHPCyRjdzZ"
    let airtable: Airtable!
    let userId: String!
    let tableClockins = "ClockIns"
    
    init(userId: String) {
        airtable = Airtable(apiKey: apiKey, apiBaseUrl: apiBaseUrl, schema: Clockin.schema)
        self.userId = userId
    }
    
    func getMyClockins(includeClockOuts: Bool, handler: @escaping ([Clockin], Error?) -> Void) {
        airtable.fetchAll(table: tableClockins) { (objects: [Clockin], error: Error?) in
            if let error = error {
                handler([], error)
            } else {
                let clockins = objects.filter{
                    $0.owner == self.userId && (includeClockOuts ? true : !$0.isClockOut)
                }
                handler(clockins, nil)
            }
        }
    }
    
    func createClockin(clockin: Clockin, handler: @escaping (Bool, Error?) -> Void) {
        airtable.createObject(with: clockin, inTable: tableClockins) { object, error in
            
            if let error = error {
                handler(false, error)
            } else {
                handler(true, nil)
            }
        }
    }
}
