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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        openDoorButton.layer.cornerRadius = 10
        clockInButton.layer.cornerRadius = 10
        recordsButton.layer.cornerRadius = 10
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
        }
    }
    
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "AuthenticationSucceeded", sender: self)
        }
    }
    
    
}

