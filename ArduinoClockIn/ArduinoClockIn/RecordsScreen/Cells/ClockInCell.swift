//
//  ClockInCell.swift
//  ArduinoClockIn
//
//  Created by Rafael Ferreira on 09/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import UIKit

class ClockInCell: UITableViewCell {
    
    @IBOutlet weak var clockInDate: UILabel!
    @IBOutlet weak var enteringTime: UILabel!
    @IBOutlet weak var leavingTime: UILabel!
    @IBOutlet weak var totalTimeWorked: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(workday: Workday) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let clockinHour = dateFormatter.string(from: workday.clockin.time)
        var clockoutHour = "--:--"
        var hours: Int = 0
        var minutes: Int = 0
        
        if let clockout = workday.clockout {
            clockoutHour = dateFormatter.string(from: clockout.time)
            var hoursWorkedSeconds = workday.clockin.time.distance(to: clockout.time)
            
            while Int(hoursWorkedSeconds) / 3600 > 0 {
                hours += 1
                hoursWorkedSeconds = hoursWorkedSeconds / 3600
            }
            
            while Int(hoursWorkedSeconds) / 60 > 0 {
                minutes += 1
                hoursWorkedSeconds = hoursWorkedSeconds / 60
            }
        }
        
        var hoursStr = "\(hours)"
        var minutesStr = "\(minutes)"
        
        if hours < 10 {
            hoursStr = "0\(hours)"
        }
        
        if minutes < 10 {
            minutesStr = "0\(minutes)"
        }
        
        self.totalTimeWorked.text = "Total: \(hoursStr)h\(minutesStr)min"
        self.leavingTime.text = clockoutHour
        self.enteringTime.text = clockinHour
        dateFormatter.dateFormat = "dd/MM"
        self.clockInDate.text = dateFormatter.string(from: workday.clockin.time)
    }
    
    
}
