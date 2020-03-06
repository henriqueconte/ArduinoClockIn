//
//  ExchangeDelegate.swift
//  ArduinoClockIn
//
//  Created by Maria Eduarda Casanova Nascimento on 06/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation

protocol ExchangeDelegate {
    func communicatorDidConnect(_ communicator: Exchange)
    func communicator(_ communicator: Exchange, didRead data: Data)
    func communicator(_ communicator: Exchange, didWrite data: Data)
}
