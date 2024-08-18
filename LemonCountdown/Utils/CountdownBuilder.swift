//
//  EventBuilder.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import Foundation
// import LemonUtils

@Observable
class EventBuilder {
    var title = ""
    var startDate: Date = .now
    var endDate: Date = .now
    var isAllDayEvent = true
    var isEnabled = true
    var icon = "chinese-valentines-day"
    var colorHex = ""
    var backgroundImage: String?

    var isRepeatEnabled = false
    var repeatPeriod: RepeatPeriod = .day
    var repeatInterval = 1
    var hasRepeatEndDate = true
    var repeatEndDate: Date = .now

    var tag: Tag?

    var eventType: EventType = .user
    var isNotificationEnabled = false
    var firstNotification: EventNotification = .none
    var secondNotification: EventNotification = .none
    var eventIdentifier = ""

    // 小组件
    var widgetTemplateModel: WidgetTemplateModel?

    init() {
    }

    func postInit(_ event: EventModel) {
        title = event.title
        startDate = event.startDate
        endDate = event.endDate
        colorHex = event.colorHex
        icon = event.icon
        isRepeatEnabled = event.isRepeatEnabled
        repeatPeriod = event.repeatPeriod
        repeatInterval = event.repeatInterval
        repeatEndDate = event.repeatEndDate ?? .now
        isNotificationEnabled = event.isNotificationEnabled
        firstNotification = event.firstNotification
        secondNotification = event.secondNotification

        if let repeatEndDate = event.repeatEndDate {
            hasRepeatEndDate = true
            self.repeatEndDate = repeatEndDate
        }

        widgetTemplateModel = event.widgetTemplateModel
        tag = event.tag
    }

    func adjustDate() {
        if isAllDayEvent {
            // startDate 为当天上午 9 点
            let startOfDay = startDate.adjust(for: .startOfDay)!
            startDate = startOfDay.offset(.hour, value: 9)!
            endDate = startOfDay.offset(.hour, value: 18)!
        }
    }

    @discardableResult
    func setTitle(_ title: String) -> EventBuilder {
        self.title = title
        return self
    }

    @discardableResult
    func setStartDate(_ date: Date) -> EventBuilder {
        startDate = date
        return self
    }

    @discardableResult
    func setEndDate(_ date: Date) -> EventBuilder {
        endDate = date
        return self
    }

    @discardableResult
    func setAllDayEvent(_ allDay: Bool) -> EventBuilder {
        isAllDayEvent = allDay
        return self
    }

    @discardableResult
    func setEnabled(_ enabled: Bool) -> EventBuilder {
        isEnabled = enabled
        return self
    }

    @discardableResult
    func setIcon(_ icon: String) -> EventBuilder {
        self.icon = icon
        return self
    }

    @discardableResult
    func setColorHex(_ colorHex: String) -> EventBuilder {
        self.colorHex = colorHex
        return self
    }

    @discardableResult
    func setBackgroundImage(_ image: String) -> EventBuilder {
        backgroundImage = image
        return self
    }

    @discardableResult
    func setRepeatEnabled(_ enabled: Bool) -> EventBuilder {
        isRepeatEnabled = enabled
        return self
    }

    @discardableResult
    func setRepeatPeriod(_ period: RepeatPeriod) -> EventBuilder {
        repeatPeriod = period
        return self
    }

    @discardableResult
    func setRepeatInterval(_ interval: Int) -> EventBuilder {
        repeatInterval = interval
        return self
    }

    @discardableResult
    func setRepeatEndDate(_ date: Date) -> EventBuilder {
        repeatEndDate = date
        return self
    }

    @discardableResult
    func setEventType(_ type: EventType) -> EventBuilder {
        eventType = type
        return self
    }

    @discardableResult
    func setFirstNotification(_ notification: EventNotification) -> EventBuilder {
        firstNotification = notification
        return self
    }

    @discardableResult
    func setSecondNotification(_ notification: EventNotification) -> EventBuilder {
        secondNotification = notification
        return self
    }

    func build() -> EventModel? {
        guard startDate < endDate else {
            print("startDate must be less than endDate")
            return nil
        }

        if isRepeatEnabled {
            guard repeatEndDate >= endDate else {
                print("repeatEndDate must be greater than endDate")
                return nil
            }
        }

        guard !title.isEmpty else {
            print("title is empty")
            return nil
        }

        guard !icon.isEmpty else {
            print("icon is empty")
            return nil
        }

        guard !colorHex.isEmpty else {
            print("colorHex is empty")
            return nil
        }

        let event = EventModel(title: title, startDate: startDate, endDate: endDate, icon: icon, colorHex: colorHex)
        event.backgroundImage = backgroundImage

        event.isAllDayEvent = isAllDayEvent
        event.isEnabled = isEnabled
        event.isRepeatEnabled = isRepeatEnabled
        event.repeatPeriod = repeatPeriod
        event.repeatInterval = repeatInterval
        if hasRepeatEndDate {
            event.repeatEndDate = repeatEndDate
        } else {
            event.repeatEndDate = nil
        }

        event.type = eventType
        event.isNotificationEnabled = isNotificationEnabled
        event.firstNotification = firstNotification
        event.secondNotification = secondNotification
        event.eventIdentifier = eventIdentifier

        event.tag = tag

        event.widgetTemplateModel = widgetTemplateModel

        return event
    }

    func notificationConfigCopy() -> EventModel {
        let event = EventModel(title: title, startDate: startDate, endDate: endDate, icon: icon, colorHex: colorHex)
        event.isAllDayEvent = isAllDayEvent
        event.isEnabled = isEnabled
        event.isRepeatEnabled = isRepeatEnabled
        event.repeatPeriod = repeatPeriod
        event.repeatInterval = repeatInterval
        if hasRepeatEndDate {
            event.repeatEndDate = repeatEndDate
        } else {
            event.repeatEndDate = nil
        }

        event.type = eventType
        event.isNotificationEnabled = isNotificationEnabled
        event.firstNotification = firstNotification
        event.secondNotification = secondNotification
        event.eventIdentifier = eventIdentifier
        return event
    }
}
