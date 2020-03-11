//
//  RecordsScreenViewController.swift
//  ArduinoClockIn
//
//  Created by Rafael Ferreira on 09/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import UIKit

class RecordsScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var workdays: [Workday] = []
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        let userId = UserDefaults.standard.value(forKey: "userID") as? String
        if let userId = userId {
            AirtableClockinDB(userId: userId).getMyClockins(includeClockOuts: true, handler: { (clockins, error) in
                if let error = error {
                    print(error)
                } else {
                    var groupedClockins: [Clockin] = []
                    var groupedClockouts: [Clockin] = []
                    let sortedClockins = clockins.sorted { clockin1, clockin2 in
                        clockin1.time < clockin2.time
                    }
                    sortedClockins.forEach {
                        if $0.isClockOut {
                            groupedClockouts.append($0)
                        } else {
                            groupedClockins.append($0)
                        }
                    }
                    
                    if groupedClockins.count == groupedClockouts.count {
                        for i in 0 ..< groupedClockins.count {
                            self.workdays.append(Workday(clockin: groupedClockins[i], clockout: groupedClockouts[i]))
                        }
                    } else {
                        for i in 0 ..< groupedClockins.count - 1 {
                            self.workdays.append(Workday(clockin: groupedClockins[i], clockout: groupedClockouts[i]))
                        }
                        self.workdays.append(Workday(clockin: groupedClockins[groupedClockins.count - 1], clockout: nil))
                    }
                    self.workdays.reverse()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
}

extension RecordsScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workdays.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ClockInCell else {return UITableViewCell()}
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as? ProfileCell else { return UITableViewCell() }
            DispatchQueue.main.async {
                cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2
                
            }
            return cell
        } else {
            cell.configure(workday: workdays[indexPath.row - 1])
            cell.contentView.viewWithTag(2)?.layer.shadowOpacity = 0.4
            cell.contentView.viewWithTag(2)?.layer.shadowRadius = 3
            cell.contentView.viewWithTag(2)?.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.contentView.viewWithTag(2)?.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.contentView.viewWithTag(2)?.layer.masksToBounds = false
        }
        return cell
    }
}
