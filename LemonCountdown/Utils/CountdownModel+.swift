//
//  EventModel+.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/5.
//

import Foundation
import LemonUtils

extension EventModel {
    var nextStartDate: Date {
        if let nextEventStartDateCache {
            return nextEventStartDateCache
        }

        if !isRepeatEnabled {
            nextEventStartDateCache = startDate
            return startDate
        }

        let diff = diffDays
        nextEventStartDateCache = Date().offset(.day, value: diff)!
        return nextEventStartDateCache!
    }

    var diffDays: Int {
        if let diffDaysCache {
            return diffDaysCache
        }

        let now = Date()
        if !isRepeatEnabled || startDate > now {
            let diff = Calendar.current.numberOfDaysBetween(now, and: startDate)
            diffDaysCache = diff
            return diff
        }
        let diff = calculateNearestRepeatDate(startDate: startDate, currentDate: now, repeatPeriod: repeatPeriod, n: repeatInterval)
        diffDaysCache = diff
        return diff
    }
}

extension EventModel {
    func updateFrom(builder cb: EventBuilder) {
        title = cb.title
        startDate = cb.startDate
        colorHex = cb.colorHex
        icon = cb.icon

        isRepeatEnabled = cb.isRepeatEnabled
        repeatPeriod = cb.repeatPeriod
        repeatInterval = cb.repeatInterval
        repeatEndDate = cb.repeatEndDate

        isNotificationEnabled = cb.isNotificationEnabled
        firstNotification = cb.firstNotification
        secondNotification = cb.secondNotification

        widgetTemplateModel = cb.widgetTemplateModel
        tag = cb.tag
    }
}
