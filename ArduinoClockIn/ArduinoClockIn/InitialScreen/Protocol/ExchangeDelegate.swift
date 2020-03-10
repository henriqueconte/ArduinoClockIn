//
//  ExchangeDelegate.swift
//  ArduinoClockIn
//
//  Created by Maria Eduarda Casanova Nascimento on 06/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation

protocol ExchangeDelegate {
    func communicatorDidConnect(_ communicator: ExchangePresenter)
    func communicator(_ communicator: ExchangePresenter, didRead data: Data)
    func communicator(_ communicator: ExchangePresenter, didWrite data: Data)
}
