//
//  DatePickerHelper.swift
//  Assignment
//
//  Created by Ranjit Singh on 04/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

class DatePickerHelper: NSObject {

    class func dateWithFormat(date:NSDate, withFormat format:String) -> String {
        let formatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }

    
    class func dateByReplacedDay(currentDate:NSDate,withDay newDay:Int) -> NSDate{
        let calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        calender?.timeZone = NSTimeZone(abbreviation: "GMT")!
        let components = calender!.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: currentDate)
        if newDay != 0 {
            components.day = newDay
        }
        return (calender?.dateFromComponents(components))!
    }
    
    
    class func dateByAddingDay(currentDate:NSDate,withDay day:Int) -> NSDate{
        let calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let components = calender!.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: currentDate)
        components.day += day
        return (calender?.dateFromComponents(components))!
    }
    
    
    class func dateByAddingHour(currentDate:NSDate,withHour hour:Int) -> NSDate{
        let calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let components = calender!.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit], fromDate: currentDate)
        components.hour += hour
        return (calender?.dateFromComponents(components))!
    }


    class func dateByAddingMonth(currentDate:NSDate, changeMonthBy value:Int) -> NSDate {
        let calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let components = calender!.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: currentDate)
        var day = Int(DatePickerHelper.dateWithFormat(currentDate, withFormat: "dd"))
        if day > 28 {
            day = 28
        }
        components.day = day!
        components.month = components.month + value
        return (calender?.dateFromComponents(components))!
    }
    
    
    class func weekdayOf1stOfTheMonth(currentMonth:Int, withYear currentYear:Int) -> Int /* Mon,Tue,...*/ {
        let components = NSDateComponents()
        components.day = 01
        components.month = currentMonth
        components.year = currentYear
        return weekDay(NSCalendar.currentCalendar().dateFromComponents(components)!)
    }
    
    
    class func weekDay(currentDate:NSDate) -> Int {
    
        let calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let components = calender!.components([.NSWeekdayCalendarUnit], fromDate: currentDate)
        return components.weekday // weekday 1 = Sunday for Gregorian calendar
    }
    
    
    class func numberOfDaysInAMonth(monthValue:Int, andYear currentYear:Int) -> Int {
        var day = 0;
        if((monthValue == 1) ||
            (monthValue == 3) ||
            (monthValue == 5) ||
            (monthValue == 7) ||
            (monthValue == 8) ||
            (monthValue == 10) ||
            (monthValue == 12) )  {
            day = 31;
        } else if
            ((monthValue == 4) ||
            (monthValue == 6) ||
            (monthValue == 9) ||
            (monthValue == 11) ) {
            day = 30;
        } else {
            if( currentYear%4 == 0){
                day = 29;
            } else {
                day = 28;
            }
        }
        return day;
    }
    
    
    class func getMonthFullName(mm:Int) -> String {
        var monthName = ""
        if(mm == 1) {
            monthName = "January";
        } else if (mm == 2) {
            monthName = "February";
        } else if (mm == 3) {
            monthName = "March";
        } else if (mm == 4) {
            monthName = "April";
        } else if (mm == 5) {
            monthName = "May";
        } else if (mm == 6) {
            monthName = "June";
        } else if (mm == 7) {
            monthName = "July";
        } else if (mm == 8) {
            monthName = "August";
        } else if (mm == 9) {
            monthName = "September";
        } else if (mm == 10) {
            monthName = "October";
        } else if (mm == 11) {
            monthName = "November";
        } else if (mm == 12) {
            monthName = "December";
        }
        return monthName;
    }
    
    
    class func getWeekDayFullName(weekday:Int) -> String {
        var dayName = ""
        if(weekday == 1) {
            dayName = "sunday";
        } else if(weekday == 2) {
            dayName = "monday";
        } else if(weekday == 3) {
            dayName = "tuesday";
        } else if(weekday == 4) {
            dayName = "wednesday";
        } else if(weekday == 5) {
            dayName = "thursday";
        } else if(weekday == 6) {
            dayName = "friday";
        } else if(weekday == 7) {
            dayName = "saturday";
        }
        return dayName;
    }
    
}