//
//  DetailEventVC.swift
//  Assignment
//
//  Created by Ranjit Singh on 08/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import EventKit
protocol DetailEventDelegate:class {
    func eventDeleted()
}

class DetailEventVC: UIViewController,AddEventDelegate {

    //MARK: Variable Declaration
    @IBOutlet weak var buttonDeleteEvent: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var locationHeightConstraint: NSLayoutConstraint!
    
    var event:EKEvent!
    let displayDateFormat = "dd, MMM yyyy   hh:mm a"
    
    
    //MARK: DetailEventDelegate Declaration
    weak var delegate:DetailEventDelegate?
    
    
    //MARK: UIViewController Methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if event.eventIdentifier.isEmpty {
            buttonDeleteEvent.enabled = false
        }
        fillData()
    }
    
    
    //MARK: Action Taken
    @IBAction func backTouched(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteEventTouched(sender: UIButton) {
        EventManager.deleteEvent(event.calendarItemIdentifier)
        delegate?.eventDeleted()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: StoryBoard and Segue Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddEvent" {
            let vc = segue.destinationViewController as! AddEventVC
            vc.selectedDate = event.startDate
            vc.event = event
            vc.page = "Edit"
            vc.delegate = self
        }
    }
    
    
    //MARK: Util Methods
    func fillData() {
        labelTitle.text = event.title
        if event.location != nil && !(event.location?.isEmpty)! {
            labelLocation.text = event.location
        } else {
            labelLocation.text = ""
            locationHeightConstraint.constant = 0
            UIView.animateWithDuration(0.35, animations: { 
                self.view.layoutIfNeeded()
            })
        }
        labelTo.text = DatePickerHelper.dateWithFormat(event.startDate, withFormat: displayDateFormat)
        if event.allDay {
            labelFrom.text = "All day"
        } else {
            labelFrom.text = DatePickerHelper.dateWithFormat(event.endDate, withFormat: displayDateFormat)
        }
        
    }
    
    //MARK: AddEventDelegate Delegates
    func eventAdded() {
        
    }
}
