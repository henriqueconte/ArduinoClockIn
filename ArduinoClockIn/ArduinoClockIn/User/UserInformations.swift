//
//  UserInformations.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 10/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation


struct User {
    
    static var sharedInstance: User = User()
    
    var id: String? {
        return UserDefaults.standard.value(forKey: "userID") as? String ?? ""
    }
    
}
