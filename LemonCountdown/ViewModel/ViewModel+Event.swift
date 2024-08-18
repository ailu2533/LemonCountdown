//
//  ViewModel+Event.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/7.
//

import Foundation
import LemonCountdownModel
import LemonUtils
import SwiftData

extension ViewModel {
    func deleteAllEvents() {
        do {
            try modelContext.delete(model: EventModel.self)
        } catch {
            Logging.shared.error("Failed to delete all events: \(error.localizedDescription)")
        }
    }

    func delete(model: EventModel) {
        modelContext.delete(model)
    }

    func fetchAllEvents() -> [EventModel] {
        Logging.shared.info("fetchAllEvents")

        let descriptor = FetchDescriptor<EventModel>()

        do {
            // Attempt to fetch all event models using the descriptor.
            return try modelContext.fetch(descriptor)
        } catch {
            Logging.shared.error("Failed to fetch events: \(error.localizedDescription)")
        }

        return []
    }

    // TODO:
    static func sort(events: [EventModel]) -> ([EventModel], [EventModel], [EventModel]) {
        // 分类计数模型基于其下一个开始日期
//        let today = Date()
//        let endOftoday = today.adjust(for: .endOfDay)!
//        let startOfToday = today.adjust(for: .startOfDay)!
//
//        let todayEvents = events.filter { Calendar.current.isDate($0.nextStartDate, inSameDayAs: today) }
//        let afterEvents = events.filter { $0.nextStartDate > endOftoday }
//        let beforeEvents = events.filter { $0.nextStartDate < startOfToday }
//
//        // 对每个分类进行排序
//        let sortedToday = todayEvents.sorted { $0.nextStartDate == $1.nextStartDate ? $0.updateDate > $1.updateDate : $0.nextStartDate < $1.nextStartDate }
//        let sortedAfter = afterEvents.sorted { $0.nextStartDate == $1.nextStartDate ? $0.updateDate > $1.updateDate : $0.nextStartDate < $1.nextStartDate }
//        let sortedBefore = beforeEvents.sorted { $0.nextStartDate == $1.nextStartDate ? $0.updateDate > $1.updateDate : $0.nextStartDate > $1.nextStartDate }
//
//        return (sortedToday, sortedAfter, sortedBefore)

        return ([], [], [])
    }

    func deleteEvent(_ event: EventModel) {
        modelContext.delete(event)
    }

    // 修改
    func modifyEvent(_ event: EventModel) {
        event.updateDate = .now
    }

    // 新增
    func addEvent(_ event: EventModel) {
        modelContext.insert(event)
    }

    func createBackupFromEvent(_ event: EventModel) -> EventBackupModel {
        Logging.widgetEntries.debug("createBackupFromEvent : \(event)")

        return EventBackupModel(
            title: event.title,
            startDate: event.startDate,
            endDate: event.endDate,
            isAllDayEvent: event.isAllDayEvent,
            isEnabled: event.isEnabled,
            recurrenceType: event.recurrenceType,
            isRepeatEnabled: event.isRepeatEnabled,
            repeatPeriod: event.repeatPeriod,
            repeatInterval: event.repeatInterval,
            repeatEndDate: event.repeatEndDate,
            repeatCustomWeekly: event.repeatCustomWeekly
        )
    }
}
