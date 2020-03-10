//
//  AuthenticationPresenter.swift
//  ArduinoClockIn
//
//  Created by Pedro Lopes on 04/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import LocalAuthentication

class AuthenticationPresenter {
    var delegate: AuthenticationProtocol!
    
    required init(delegate: AuthenticationProtocol) {
        self.delegate = delegate
    }
    
    func authenticate() {
        let context = LAContext()
        context.localizedCancelTitle = "Não deu, irmão"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    self.delegate.authenticationSuccess()
                } else if let error = error {
                    self.delegate.authenticationError(error)
                }
            }
        }
    }
}
