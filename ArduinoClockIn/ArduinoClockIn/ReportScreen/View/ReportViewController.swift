//
//  ReportViewController.swift
//  ArduinoClockIn
//
//  Created by Maria Eduarda Casanova Nascimento on 10/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.dataSource = self
//        reportTableView.delegate = self
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
    }
}

extension ReportViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cellIdentifier = "headerCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReportHeaderTableViewCell  else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.backgroundColor = .clear
            return cell
        }else if indexPath.section == 1{
            let cellIdentifier = "infoCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InfoTableViewCell  else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.cardView.layer.shadowColor = #colorLiteral(red: 0, green: 0.2994042933, blue: 0.6254397035, alpha: 1)
            cell.cardView.layer.shadowOpacity = 0.3
            cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.cardView.layer.shadowRadius = 5
            
            cell.cardView.layer.cornerRadius = 10
            cell.dateText.text = "Semana 0/0 a 0/0"
            cell.timeText.text = "Total: 0h"
            cell.backgroundColor = .clear
            return cell
        }else{
            let cellIdentifier = "infoCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InfoTableViewCell  else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.cardView.layer.shadowColor = #colorLiteral(red: 0, green: 0.2994042933, blue: 0.6254397035, alpha: 1)
            cell.cardView.layer.shadowOpacity = 0.3
            cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.cardView.layer.shadowRadius = 5
            
            cell.cardView.layer.cornerRadius = 10
            cell.dateText.text = "MARÇO"
            cell.timeText.isHidden = true
            cell.timeText.text = "Total: 8h"
            cell.backgroundColor = .clear
            return cell
        }
    }
    
}

//extension ReportViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 { return 300 }
//        else { return UITableView.automaticDimension }
////        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
