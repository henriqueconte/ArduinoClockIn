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
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor().colorWithGradient(frame: view.frame, colors: [#colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
    }
}

extension ReportViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "headerCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReportHeaderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        cell.backgroundColor = .clear
        return cell
    }
}
