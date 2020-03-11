//
//  ViewController.swift
//  ArduinoClockIn
//
//  Created by Henrique Figueiredo Conte on 03/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var openDoorButton: UIButton!
    @IBOutlet weak var clockInButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    var token: String?
    var userName: String?
    var clockInPressed = false
    var blackBlur: UIView!
    private var communicator: ExchangePresenter!  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blackBlur = UIView()
        blackBlur.frame = self.view.bounds
        blackBlur.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4536065925)
        let loader = UIActivityIndicatorView()
        loader.frame = CGRect(x: blackBlur.frame.midX - 15, y: blackBlur.frame.midY - 15, width: 30, height: 30)
        loader.style = .large
        loader.startAnimating()
        blackBlur.addSubview(loader)
        self.view.addSubview(blackBlur)
        blackBlur.isHidden = true
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        openDoorButton.layer.cornerRadius = 10
        clockInButton.layer.cornerRadius = 10
        recordsButton.layer.cornerRadius = 10
        
        self.communicator = ExchangePresenter(delegate: self)

        token = UserDefaults.standard.value(forKey: "userID") as? String
        userName = UserDefaults.standard.value(forKey: "userName") as? String
        
        self.clockInButton.setTitle((UserDefaults.standard.value(forKey: "clockedIn") as? Bool ?? false) ? "Clock Out" : "Clock In", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateClockInButtonLabel(_:)), name: NSNotification.Name(rawValue: "updateClockInButtonName"), object: nil)
//        if let token = token {
//            AirtableClockinDB(userId: token).getMyClockins(includeClockOuts: true) { clockins, error in
//                print("oi")
//            }
//        }
    }
    
    @objc func updateClockInButtonLabel(_ sender: NSNotification) {
        DispatchQueue.main.async {
            self.clockInButton.setTitle((UserDefaults.standard.value(forKey: "clockedIn") as? Bool ?? false) ? "Clock Out" : "Clock In", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ClockInViewController {
            vc.token = token
            vc.userName = userName
            if clockInPressed {
                clockInPressed = false
                vc.clockinShouldHide = true
            }
        }
    }

    // @IBAction func send(_ sender: Any) {
    //     self.communicator.send(value: "A")
    // }
    
    @IBAction func OperDoorButtonPressed(_ sender: UIButton) {
        clockInPressed = false
        AuthenticationPresenter(delegate: self).authenticate()
    }
    
    @IBAction func ClockInButtonPressed(_ sender: UIButton) {
        clockInPressed = true
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
        if clockInPressed { 
            if let token = token { // tag == 1 means 👍
                
                DispatchQueue.main.async {
                    self.blackBlur.isHidden = false
                }
                let clockedIn = UserDefaults.standard.value(forKey: "clockedIn") as? Bool ?? false
                AirtableClockinDB(userId: token).createClockin(clockin: Clockin(id: UUID().uuidString, time: Date(), isClockOut: clockedIn, owner: token, name: userName ?? "")) { success, error in
                    if success {
                        UserDefaults.standard.set(!clockedIn, forKey: "clockedIn")
                        NotificationCenter.default.post(name: Notification.Name("updateClockInButtonName"), object: nil)
                        DispatchQueue.main.async {
                            self.blackBlur.isHidden = true
                            self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.blackBlur.isHidden = true
                            let alert = UIAlertController(title: "Some error occurred, try again", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else {          // Door opened withou clock in
            self.communicator.send(value: "A")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
            }
        }
    }
    
    
}

extension ViewController: ExchangeDelegate{
    func communicatorDidConnect(_ communicator: ExchangePresenter) {
//        view.backgroundColor = .gray
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


