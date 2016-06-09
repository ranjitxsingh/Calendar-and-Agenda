//
//  AddEventVC.swift
//  Assignment
//
//  Created by Ranjit Singh on 08/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import EventKit

protocol AddEventDelegate:class {
    func eventAdded()
}

class AddEventVC: UIViewController,UITextFieldDelegate {

    //MARK: Stored Properties
    @IBOutlet weak var txtFldTitle: UITextField!
    @IBOutlet weak var txtFldLocation: UITextField!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelStarts: UILabel!
    @IBOutlet weak var labelEnds: UILabel!
    @IBOutlet weak var switchAllDay: UISwitch!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var eventId:String!
    var selectedDate:NSDate!
    var event:EKEvent!
    var page:String!
    var isStratsPresent:Bool = false
    var isEndsPresent:Bool = false
    let displayDateFormat = "dd, MMM yyyy   hh:mm a"
    
    //MARK: Computed Properties
    var startDate:NSDate = NSDate() {
        willSet(value) {
            labelStarts.text = DatePickerHelper.dateWithFormat(value, withFormat: displayDateFormat)
        }
    }
    var endDate:NSDate = NSDate() {
        willSet(value) {
            labelEnds.text = DatePickerHelper.dateWithFormat(value, withFormat: displayDateFormat)
        }
    }
    
    
    //MARK: AddEventDelegate Declaration
    weak var delegate:AddEventDelegate?
    

    //MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerBottomConstraint.constant = -viewDatePicker.frame.size.height
        if page != nil {
            navigationItem.rightBarButtonItem?.title = "Done"
            prefill()
        }
        startDate = selectedDate
        endDate = DatePickerHelper.dateByAddingHour(startDate, withHour: 1)
    }
    
    
    //MARK: Action Taken
    @IBAction func cancelTouched(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTouched(sender: AnyObject) {
        if event != nil {
            EventManager.addEditEvent(txtFldTitle.text!, location: txtFldLocation.text!, starDate: startDate, endDate: endDate, allDay: switchAllDay.on, eventId:event.eventIdentifier)
        } else {
            EventManager.addEditEvent(txtFldTitle.text!, location: txtFldLocation.text!, starDate: startDate, endDate: endDate, allDay: switchAllDay.on)
        }
        dismissViewControllerAnimated(true, completion:{
            self.delegate?.eventAdded()
        })
    }
    
    @IBAction func startsTouched(sender: UIButton) {
        isStratsPresent = !isStratsPresent
        isEndsPresent = false
        labelEnds.textColor = UIColor.msBlackColor()
        if isStratsPresent {
            labelStarts.textColor = UIColor.redColor()
        } else {
            labelStarts.textColor = UIColor.msBlackColor()
        }
        loadDatePicker()
        
    }
    
    @IBAction func endsTouched(sender: AnyObject) {
        isEndsPresent = !isEndsPresent
        isStratsPresent = false
        labelStarts.textColor = UIColor.msBlackColor()
        if isEndsPresent {
            labelEnds.textColor = UIColor.redColor()
        } else {
            labelEnds.textColor = UIColor.msBlackColor()
        }
        loadDatePicker()
    }
    
    @IBAction func datePickerDoneTouched(sender: AnyObject) {
        isStratsPresent = false
        isEndsPresent = false
        labelStarts.textColor = UIColor.msBlackColor()
        labelEnds.textColor = UIColor.msBlackColor()
        loadDatePicker()
    }
    
    //MARK: Util Methods
    func loadDatePicker() {
        self.view.endEditing(true)
        if isStratsPresent {
            datePicker.date = startDate
        } else {
            datePicker.date = endDate
        }
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), forControlEvents: .ValueChanged)
        if isStratsPresent || isEndsPresent {
            datePickerBottomConstraint.constant = 0
        } else {
            datePickerBottomConstraint.constant = -viewDatePicker.frame.size.height
        }
        UIView.animateWithDuration(0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    func datePickerChanged(sender:UIDatePicker) {
        if isStratsPresent {
            startDate = sender.date
        } else {
            endDate = sender.date
        }
    }
    
    func prefill() {
        txtFldTitle.text = event.title
        txtFldLocation.text = event.location
        startDate = event.startDate
        endDate = event.endDate
        switchAllDay.on = event.allDay
    }
    
    
    //MARK: UITextField Delagate Methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(string)
        
        if string.characters.count == 0 && textField.text?.characters.count == 1 {
            navItem.rightBarButtonItem?.enabled = false
        } else if((string.characters.count + (textField.text?.characters.count)!) > 0) {
            navItem.rightBarButtonItem?.enabled = true
        } else {
            navItem.rightBarButtonItem?.enabled = false
        }

        return true
    }
}
