//
//  Clockin.swift
//  ArduinoClockIn
//
//  Created by Rafael Ferreira on 09/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation

struct Clockin {
    var id: String = ""
    var time: Date = Date()
    var isClockOut: Bool = false
    var owner: String = ""
}
