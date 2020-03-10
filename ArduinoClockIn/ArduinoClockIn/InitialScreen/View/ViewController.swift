//
//  ViewController.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 03/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var OpenDoorButton: UIButton!
    @IBOutlet weak var ClockInButton: UIButton!
    @IBOutlet weak var RecordsButton: UIButton!

    private var communicator: ExchangePresenter!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        OpenDoorButton.layer.cornerRadius = 10
        ClockInButton.layer.cornerRadius = 10
        RecordsButton.layer.cornerRadius = 10

        self.communicator = ExchangePresenter(delegate: self)
    }

    // @IBAction func send(_ sender: Any) {
    //     self.communicator.send(value: "A")
    // }
    
    @IBAction func OperDoorButtonPressed(_ sender: UIButton) {
        AuthenticationPresenter(delegate: self).authenticate()
    }
    
    @IBAction func ClockInButtonPressed(_ sender: UIButton) {
        AuthenticationPresenter(delegate: self).authenticate()
    }
    
    @IBAction func RecordsButtonPressed(_ sender: UIButton) {
    }
    
    
    

}

extension ViewController: AuthenticationProtocol {
    func authenticationError(_ error: Error) {
        print(error.localizedDescription)
        // Do something if error
    }
    
    func authenticationSuccess() {
        // Move to the main thread because a state update triggers UI changes.
        self.communicator.send(value: "A")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
        }
    }
    
    
}

extension ViewController: ExchangeDelegate{
    func communicatorDidConnect(_ communicator: ExchangePresenter) {
        view.backgroundColor = .gray
    }
    
    func communicator(_ communicator: ExchangePresenter, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8) ?? "ERROR READ ")
    }
    
    func communicator(_ communicator: ExchangePresenter, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8) ?? "ERROR WRITE")
    }
    
}


