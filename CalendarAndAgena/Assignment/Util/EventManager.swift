//
//  EventManager.swift
//  Assignment
//
//  Created by Ranjit Singh on 08/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit
import EventKit

class EventManager: NSObject {

    
    //Get all events by Date
    class func getAllEvents(date:NSDate, completed:([EKEvent]->())) {
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let endDate = DatePickerHelper.dateByAddingDay(date, withDay: 1)
            let predicate = store.predicateForEventsWithStartDate(date, endDate: endDate, calendars: nil)
            completed(store.eventsMatchingPredicate(predicate))
        }
    }
    
    
    //Add or Edit Event
    class func addEditEvent(title:String, location:String, starDate:NSDate, endDate:NSDate, allDay:Bool, eventId:String? = nil) {
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            var event = EKEvent(eventStore: store)
            if let id = eventId, oldEvent = store.eventWithIdentifier(id) {
                event = oldEvent
            }
            event.title = title
            event.location = location
            event.startDate = starDate
            event.endDate = endDate
            event.allDay = allDay
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.saveEvent(event, span: .ThisEvent, commit: true)
            } catch {
                // Display error to user
            }
        }
    }
    
    
    //Delete Event
    class func deleteEvent(eventId:String) {
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.eventWithIdentifier(eventId)
            if eventToRemove != nil {
                do {
                    try store.removeEvent(eventToRemove!, span: .ThisEvent, commit: true)
                } catch {
                    // Display error to user
                }
            }
        }
    }
}
