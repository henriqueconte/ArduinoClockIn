//
//  ViewController.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 03/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
    }
    @IBAction func testAction(_ sender: UIButton) {
        AuthenticationPresenter(delegate: self).authenticate()
    }
    

}

extension ViewController: AuthenticationProtocol {
    func authenticationError(_ error: Error) {
        print(error.localizedDescription)

        // Do something if error
    }
    
    func authenticationSuccess() {
        // Move to the main thread because a state update triggers UI changes.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.testButton.setTitle("Deu certo!", for: .normal)
            self.testButton.isEnabled = false
            
            self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
        }
    }
    
    
}

