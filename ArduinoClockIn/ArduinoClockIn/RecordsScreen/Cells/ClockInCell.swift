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
    
    @IBOutlet weak var ClockInDate: UILabel!
    @IBOutlet weak var EnteringTime: UILabel!
    @IBOutlet weak var LeavingTime: UILabel!
    @IBOutlet weak var totalTimeWorked: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
