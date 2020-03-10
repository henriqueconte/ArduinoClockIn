//
//  ClockInViewController.swift
//  ArduinoClockIn
//
//  Created by Rafael Ferreira on 05/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import UIKit
import SwiftAirtable

class ClockInViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    var token: String?
    var userName: String?
    
    @IBAction func TouchCancel(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func ReleaseButtonInside(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let token = token, sender.tag == 1 { // tag == 1 means 👍
            let blackBlur = UIView()
            blackBlur.frame = view.bounds
            blackBlur.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4536065925)
            let loader = UIActivityIndicatorView()
            loader.frame = CGRect(x: blackBlur.frame.midX - 15, y: blackBlur.frame.midY - 15, width: 30, height: 30)
            loader.style = .large
            loader.startAnimating()
            blackBlur.addSubview(loader)
            view.addSubview(blackBlur)
            let clockedIn = UserDefaults.standard.value(forKey: "clockedIn") as? Bool ?? false
            AirtableClockinDB(userId: token).createClockin(clockin: Clockin(id: UUID().uuidString, time: Date(), isClockOut: clockedIn, owner: token, name: userName ?? "")) { success, error in
                if success {
                    UserDefaults.standard.set(!clockedIn, forKey: "clockedIn")
                    NotificationCenter.default.post(name: Notification.Name("updateClockInButtonName"), object: nil)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        blackBlur.removeFromSuperview()
                    
                        let alert = UIAlertController(title: "Some error occurred, try again", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func PressedNegativeButton(_ sender: UIButton) {
        negativeButton.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
    }
    
    @IBAction func PressedPositiveButton(_ sender: UIButton) {
        positiveButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePicture.image = UIImage(named: "Profile_Test")
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
    }
    
    override func viewDidLayoutSubviews() { //Roda toda vez que uma subview é atualizada
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
        
        negativeButton.layer.cornerRadius = 10
        negativeButton.layer.borderColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
        negativeButton.layer.borderWidth = 1
        negativeButton.setImage(UIImage(named: "NegativeButtonWhite"), for: .highlighted)
        negativeButton.setImage(UIImage(named: "NegativeButton"), for: .normal)
        
        positiveButton.layer.cornerRadius = 10
        positiveButton.layer.borderColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        positiveButton.layer.borderWidth = 1
        positiveButton.setImage(UIImage(named: "PositiveButtonWhite"), for: .highlighted)
        positiveButton.setImage(UIImage(named: "PositiveButton"), for: .normal)
    }
}
