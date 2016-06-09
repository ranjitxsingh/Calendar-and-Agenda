//
//  EventDetailCell.swift
//  Assignment
//
//  Created by Ranjit Singh on 08/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import EventKit

class EventDetailCell: UITableViewCell {

    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(event:EKEvent) {

        labelTitle.text = event.title
        labelLocation.text = event.location
        
//        if let location = event.location {
//            labelLocation.text = location
//        } else {
//            labelLocation.text = ""
//        }
        
        if event.allDay {
            labelStartTime.text = "all-day"
            labelEndTime.text = ""
        } else {
            labelStartTime.text = DatePickerHelper.dateWithFormat(event.startDate, withFormat: "hh:mm a")
            labelEndTime.text = DatePickerHelper.dateWithFormat(event.endDate, withFormat: "hh:mm a")
        }
        
    }
}
