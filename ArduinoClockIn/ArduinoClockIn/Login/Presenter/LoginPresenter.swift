//
//  LoginPresenter.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 05/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import AuthenticationServices
import Foundation
import UIKit


class LoginPresenter  {
    
}

extension LoginPresenter: LoginProtocol {
    
    func saveLoggedUser(userID: String, userName: String) {
        UserDefaults.standard.setValue(userID, forKey: "userID")
        UserDefaults.standard.setValue(userName, forKey: "userName")
    }
}

