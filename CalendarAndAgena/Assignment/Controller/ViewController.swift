//
//  ViewController.swift
//  Assignment
//
//  Created by Ranjit Singh on 04/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,AddEventDelegate {

    //MARK: Alias names
    typealias Helper = DatePickerHelper
    
    //MARK: Variables
    @IBOutlet weak var datePickerScrollView: DatePickerScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDate = NSDate()
    var eventList = [EKEvent]()
    
    //MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerScrollView.datePickerDelegate = self
        reloadEvents()
    }
    
    
    //MARK: Date Picker Delegate Method
    func currentDate(latestDate date: NSDate) {
        let month = Helper.getMonthFullName(Int(Helper.dateWithFormat(date, withFormat: "MM"))!)
        let year = Helper.dateWithFormat(date, withFormat: "yyyy")
        self.navigationItem.title = "\(month) \(year)"
    }
    
    
    //MARK: Actions Taken
    func selectedDate(selectedDate date: NSDate) {
        self.selectedDate = date
        reloadEvents()
    }
    
    
    //MARK: StoryBoard and Segue Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddEvent" {
            let vc = segue.destinationViewController as! AddEventVC
            vc.selectedDate = self.selectedDate
            vc.delegate = self
        } else if segue.identifier == "DetailEvent" {
            let vc = segue.destinationViewController as! DetailEventVC
            let indexPath = tableView.indexPathForSelectedRow
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            vc.event = eventList[indexPath!.row]
        }
    }
    
    
    //MARK: TableView Delagates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventList.count > 0) ? eventList.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if eventList.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventDetailCell") as! EventDetailCell
            cell.config(eventList[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("EventErrorCell")!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    //MARK: AddEventDelegate Delagates
    func eventAdded() {
        reloadEvents()
    }
    
    
    //MARK: Util Methods
    func reloadEvents() {
        EventManager.getAllEvents(self.selectedDate) { (events) in
            self.eventList = events
            print(events)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
}

