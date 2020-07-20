//
//  DataConvertible.swift
//  ArduinoClockIn
//
//  Created by Maria Eduarda Casanova Nascimento on 06/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation

protocol DataConvertible {
    var data: Data { get }
}

extension Data: DataConvertible {
    var data: Data { return self }
}
extension String : DataConvertible {
    var data: Data { return self.data(using: .utf8) ?? Data() }
}

extension UInt8: DataConvertible {
    var data: Data {
        return Data.init(bytes: [self])
    }
}
