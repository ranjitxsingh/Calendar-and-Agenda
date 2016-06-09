//
//  DatePickerScrollView.swift
//  Assignment
//
//  Created by Ranjit Singh on 04/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

protocol DatePickerDelegate:class {
    func currentDate(latestDate date:NSDate)
    func selectedDate(selectedDate date:NSDate)
}

class DatePickerScrollView: UIScrollView,UIScrollViewDelegate {

    //MARK: Alias names
    typealias Helper = DatePickerHelper
    
    //MARK: Variables
    var latestDate:NSDate       = NSDate()
    var selectedDate:NSDate     = NSDate()
    var xInitialValue:Int       = 0
    var btnTag:Int              = 1
    var currentOffsetX:CGFloat  = 0
    var currentPageNumber:Int   = 0
    
    //MARK: DatePickerDelegate Declaration
    weak var datePickerDelegate:DatePickerDelegate?
    
    
    //MARK: Initialise and load Initial Data
    override init(frame: CGRect) {
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        loadInitialData()
    }
    
    func loadInitialData() {
        self.delegate = self //set delegate
        
        //Create total 5 calendars using scrollview pagging property
        for index in 0...4 {
            
            //Create 7x6 matrix to show a Calender
            createGridView(xInitialValue)
            
            //Draw calender data from currentDate-2 to currentDate+2
            let date = DatePickerHelper.dateByAddingMonth(NSDate(), changeMonthBy: index-2)
            drawCalender(date, withButtonTag:index*42)
            xInitialValue += Int(self.frame.size.width)
            
            //Increase scrollview content after adding a calendar view
            self.contentSize = CGSize(width: CGFloat(xInitialValue), height: self.frame.size.height)
        }
        
        latestDate = NSDate()
        
        //Show content of 3rd page of scrollview
        self.contentOffset.x = self.frame.size.width*2
        
        currentOffsetX = self.contentOffset.x
        currentPageNumber = Int(self.contentOffset.x/self.frame.size.width)
        
        //DatePickerDelegate method to show current month and year at navigation title
        datePickerDelegate?.currentDate(latestDate: latestDate)
    }

    
    /// This function is used to create 7x6 grid view
    func createGridView(xCord: Int) {
        
        var xCord = CGFloat(10 + xInitialValue)
        var yCord:CGFloat = 0
        // 10, 10 left and right padding and 5 for padding beween buttons
        let btnWidth:CGFloat = (self.frame.size.width - 50)/7
        let btnHeight:CGFloat = (self.frame.size.height - 50)/6
        
        for _ in 0...5 {
            for _ in 0...6 {
                let rect = CGRectMake(xCord, yCord, btnWidth, btnHeight)
                let button = UIButton(frame:rect)
                button.addTarget(self, action: #selector(dateTouched(_:)), forControlEvents: .TouchUpInside)
                xCord += CGFloat(btnWidth + 5)
                button.tag = btnTag
                button.backgroundColor = UIColor.clearColor()
                button.setTitle(String(btnTag), forState: .Normal)
                btnTag += 1
                self.addSubview(button)
            }
            xCord = CGFloat(10+xInitialValue)
            yCord += (btnHeight + 5)
        }
    }

    /// This function is used to get selected date and draw a background color for selected view
    func dateTouched(sender:UIButton) {
        
        let day = Int(sender.titleForState(.Normal)!)
        selectedDate = Helper.dateByReplacedDay(latestDate, withDay: day!)
        drawCalender(latestDate, withButtonTag: currentPageNumber*42)
        datePickerDelegate?.selectedDate(selectedDate: selectedDate)
        print("\(day!)")
        
    }
    
    /// This function is used to draw calendar data for a month
    func drawCalender(currentDate:NSDate, withButtonTag tag:Int) {
        latestDate = currentDate
        let currentMonth = Int(Helper.dateWithFormat(currentDate, withFormat: "MM"))
        let currentYear = Int(Helper.dateWithFormat(currentDate, withFormat: "yyyy"))
        
        var day = Helper.weekdayOf1stOfTheMonth(currentMonth!, withYear: currentYear!)
        day += tag
        var startDate:Int = 0
        var numberOfDaysInMonth:Int = 0
        
        //Draw previous month data and its user interaction is disabled.
        var prevMonth = currentMonth! - 1
        if(currentMonth == 1){
            prevMonth = 12;
        }
        numberOfDaysInMonth = Helper.numberOfDaysInAMonth(prevMonth, andYear: currentMonth!)
        startDate = numberOfDaysInMonth
        
        for(var index = day-1; index > tag; index -= 1) {
            if let btn = self.viewWithTag(index) as? UIButton {
                btn.setTitle(String(startDate), forState: .Normal)
                btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                btn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Light", size: 17)
                btn.userInteractionEnabled = false
                startDate -= 1
            }
        }
        
        //Draw current month data and its user interaction is enabled.
        startDate = 1;
        numberOfDaysInMonth = Helper.numberOfDaysInAMonth(currentMonth!, andYear: currentYear!)
        
        for index in day...(numberOfDaysInMonth + day) {
            if let btn = self.viewWithTag(index) as? UIButton {
                btn.setTitle(String(startDate), forState: .Normal)
                btn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Regular", size: 17)
                btn.userInteractionEnabled = true
                
                let date = Helper.dateByReplacedDay(latestDate, withDay: startDate)
                if date.equalToDate(Helper.dateByReplacedDay(selectedDate, withDay: 0)) {
                    btn.backgroundColor = UIColor.redColor()
                    btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                } else {
                    btn.backgroundColor = UIColor.clearColor()
                    btn.setTitleColor(UIColor.msBlackColor(), forState: .Normal)
                }
                startDate += 1
            }
        }
        
        //Draw next month data and its user interaction is disabled.
        let loopCount = 42 + tag - (numberOfDaysInMonth + day - 1);
        startDate = 1;
        for index in 42+tag-(loopCount-1)...(42+tag) {
            if let btn = self.viewWithTag(index) as? UIButton {
                btn.setTitle(String(startDate), forState: .Normal)
                btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                btn.backgroundColor = UIColor.clearColor()
                btn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Light", size: 17)
                btn.userInteractionEnabled = false
                startDate += 1
            }
        }
    }
    
    ///Scrollview delegate methods
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var currentDate:NSDate
        if scrollView.contentOffset.x == 0 {
            let rect = CGRect(x: self.frame.width*4, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.scrollRectToVisible(rect, animated: false)
        } else if scrollView.contentOffset.x == self.frame.size.width*4 {
            scrollView.contentOffset.x = 0
        }
        
        let pageNumber = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        let offsetX = scrollView.contentOffset.x
        if (currentPageNumber-1 == pageNumber && currentOffsetX > offsetX) ||
            (currentPageNumber == 1 && pageNumber == 4 && offsetX > currentOffsetX){ //Swiping left (Previous date to render)
            print("Show previous Date")
            currentDate = Helper.dateByAddingMonth(latestDate, changeMonthBy: -1)
        } else if (currentPageNumber+1 == pageNumber && currentOffsetX < offsetX) ||
            (currentPageNumber == 3 && pageNumber == 0 && offsetX < currentOffsetX) { //Swiping Right (Next date to render)
            print("Show Next Date")
            currentDate = Helper.dateByAddingMonth(latestDate, changeMonthBy: 1)
        } else { // Neither left nor right (Current Date to render)
            print("Show Current Date")
            currentDate = Helper.dateByAddingMonth(latestDate, changeMonthBy: 0)
        }
        currentOffsetX = offsetX
        currentPageNumber = pageNumber
        
        print("Content Offset: \(scrollView.contentOffset.x)")
        print("Page Number: \(pageNumber)")
        
        drawCalender(currentDate, withButtonTag: Int(pageNumber)*42)
        
        // Delegate Method
        datePickerDelegate?.currentDate(latestDate: currentDate)
    }
    
}