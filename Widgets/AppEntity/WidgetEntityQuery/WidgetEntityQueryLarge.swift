//
//  WidgetEntityQueryLarge.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import AppIntents
import Foundation
//
// struct WidgetEntityQueryLarge: AppEntity, EventInfoProvider {
//    static var defaultQuery: WidgetEntityQueryLargeEntityQuery {
//        return WidgetEntityQueryLargeEntityQuery()
//    }
//
//    static var typeDisplayRepresentation: TypeDisplayRepresentation {
//        return TypeDisplayRepresentation(name: "Large Widget")
//    }
//
//    var displayRepresentation: DisplayRepresentation {
//        return DisplayRepresentation(title: "\(widgetTitle)", subtitle: "\(eventTitle)")
//    }
//
//    var id: UUID
//
//    // widgetTemplateModel中的uuid
//    var widgetTemplateUUID: UUID
//
//    // 标题
//    var widgetTitle: String
//    // 事件标题
//    var eventTitle: String
//
//    // 事件结束时间
//    var endDate: Date
//    // 下一次的事件开始时间
//    var nextStartDate: Date
//    // 下一次的事件结束时间
//    var nextEndDate: Date
//    // 今天与下一次到期时间的间隔
//    var daysUntilNextStart: Int
//    // 是否是重复事件
//    var isRepeatEnabled: Bool
//    // 是否是全天事件
//    var isAllDayEvent: Bool
//
//    var jsonData: String
//
//    init(id: UUID = UUID(), widgetTemplateUUID: UUID, widgetTitle: String, eventTitle: String, endDate: Date, nextStartDate: Date, nextEndDate: Date, isRepeatEnabled: Bool, isAllDayEvent: Bool, jsonData: String) {
//        daysUntilNextStart = Calendar.current.numberOfDaysBetween(Date(), and: nextEndDate)
//        self.id = id
//        self.widgetTemplateUUID = widgetTemplateUUID
//        self.widgetTitle = widgetTitle
//        self.eventTitle = eventTitle
//        self.endDate = endDate
//        self.nextStartDate = nextStartDate
//        self.nextEndDate = nextEndDate
//        self.isRepeatEnabled = isRepeatEnabled
//        self.isAllDayEvent = isAllDayEvent
//        self.jsonData = jsonData
//    }
// }
//
// struct WidgetEntityQueryLargeEntityQuery: EntityQuery {
//    func entities(for identifiers: [UUID]) async throws -> [WidgetEntityQueryLarge] {
//        return await WidgetModelHelper.fetchLargeWidget()
//    }
//
//    func suggestedEntities() async throws -> [WidgetEntityQueryLarge] {
//        return await WidgetModelHelper.fetchLargeWidget()
//    }
//
//    func defaultResult() async -> WidgetEntityQueryLarge? {
//        return nil
//    }
// }
