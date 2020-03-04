//
//  AuthenticationProtocol.swift
//  ArduinoClockIn
//
//  Created by Pedro Lopes on 04/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    func authenticationError(_ error: Error)
    func authenticationSuccess()
}
