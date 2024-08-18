//
//  CalendarUtils.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/4.
//

import EventKit
import Foundation
import LemonUtils
import Shift

class CalendarUtils {
    // 原来没有提醒
    static func addNotification(_ newModel: EventModel) async {
        if newModel.isNotificationEnabled {
            do {
                var event: EKEvent

                if let eventIdentifier = newModel.eventIdentifier, !eventIdentifier.isEmpty, let ev = Shift.shared.eventStore.event(withIdentifier: eventIdentifier) {
                    event = ev
                } else {
                    event = try await Shift.shared.createEvent(newModel.title, startDate: newModel.startDate, endDate: newModel.endDate, isAllDay: newModel.isAllDayEvent)
                }

                // 保存事件id
                newModel.eventIdentifier = event.eventIdentifier

                // 新增提醒
                if newModel.firstNotification != .none {
                    event.addAlarm(.init(relativeOffset: newModel.firstNotification.time))
                }

                if newModel.secondNotification != .none {
                    event.addAlarm(.init(relativeOffset: newModel.secondNotification.time))
                }

                // 重复
                if newModel.isRepeatEnabled {
                    guard let freq = EKRecurrenceFrequency(rawValue: newModel.repeatPeriod.rawValue) else {
                        return
                    }

                    var repeatEnd: EKRecurrenceEnd?
                    if let repeatEndDate = newModel.repeatEndDate {
                        repeatEnd = .init(end: repeatEndDate)
                    }

                    event.addRecurrenceRule(.init(recurrenceWith: freq, interval: newModel.repeatInterval, end: repeatEnd))
                }

                try Shift.shared.eventStore.save(event, span: .futureEvents)
            } catch {
                print(error)
            }
        }
    }

    static func modifyNotification(origin: EventModel, modified: EventModel, cb: EventBuilder) async {
        guard let eventIdentifier = modified.eventIdentifier,
              let event = Shift.shared.eventStore.event(withIdentifier: eventIdentifier) else {
            if modified.isNotificationEnabled {
                await addNotification(modified)
            }
            return
        }

        updateEventDetails(event, with: modified)
        await updateAlarms(for: event, with: modified)
        await updateRecurrenceRules(for: event, with: modified)

        do {
            try Shift.shared.eventStore.save(event, span: .futureEvents)
            print("保存成功")
        } catch {
            print("Failed to save event changes: \(error.localizedDescription)")
        }
    }

    private static func updateEventDetails(_ event: EKEvent, with model: EventModel) {
        event.startDate = model.startDate
        event.endDate = model.endDate
        event.isAllDay = model.isAllDayEvent
    }

    private static func updateAlarms(for event: EKEvent, with model: EventModel) async {
        guard model.isNotificationEnabled else {
            event.alarms?.forEach(event.removeAlarm)
            return
        }

        let newAlarms = [model.firstNotification, model.secondNotification].compactMap { $0 }.map {
            EKAlarm(relativeOffset: $0.time)
        }

        if let existingAlarms = event.alarms, Set(newAlarms.map(\.relativeOffset)) == Set(existingAlarms.map(\.relativeOffset)) {
            return // No change in alarms
        }

        event.alarms?.forEach(event.removeAlarm)
        newAlarms.forEach(event.addAlarm)
    }

    private static func updateRecurrenceRules(for event: EKEvent, with model: EventModel) async {
        print("updateRecurrenceRules")
        guard model.isRepeatEnabled, let frequency = EKRecurrenceFrequency(rawValue: model.repeatPeriod.rawValue) else {
            event.recurrenceRules?.forEach(event.removeRecurrenceRule)
            print("remove all old")
            return
        }

        let newRule = EKRecurrenceRule(recurrenceWith: frequency, interval: model.repeatInterval, end: model.repeatEndDate.map(EKRecurrenceEnd.init))

        if let existingRule = event.recurrenceRules?.first, existingRule == newRule {
            print("No change in recurrence rules")
            return // No change in recurrence rules
        }

        event.recurrenceRules?.forEach(event.removeRecurrenceRule)
        print("remove old rules")
        event.addRecurrenceRule(newRule)
    }
}
