//
//  ViewController.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 03/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    private var communicator: Exchange!
    //Buttuons
    @IBOutlet weak var testButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.communicator = Exchange(delegate: self)
    }
    
    @IBAction func send(_ sender: Any) {
        self.communicator.send(value: "A")
    }
    
    
    @IBAction func testAction(_ sender: UIButton) {
        AuthenticationPresenter(delegate: self).authenticate()
    }
    
    
//    code to send information to arduino
//    @IBAction func updateInformation(_ sender: UIButton) {
//
//        // Send code that signifies arduino to update its state
//        self.communicator.send(value: "A")
//    }
    

}

extension ViewController: ExchangeDelegate{
    func communicatorDidConnect(_ communicator: Exchange) {
//        self.loadingComponent.removeLoadingIndicators(from: self.view)
        view.backgroundColor = .gray
    }
    
    func communicator(_ communicator: Exchange, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8) ?? "ERROR")
    }
    
    func communicator(_ communicator: Exchange, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8) ?? "ERROR")
    }
    
}
extension ViewController: AuthenticationProtocol {
    func authenticationError(_ error: Error) {
        print(error.localizedDescription)
        
        // Do something if error
    }
    
    func authenticationSuccess() {
        // Move to the main thread because a state update triggers UI changes.
        DispatchQueue.main.async { [unowned self] in
            self.testButton.setTitle("Deu certo!", for: .normal)
            self.testButton.isEnabled = false
        }
    }
    
    
}

