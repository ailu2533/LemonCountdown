//
//  WidgetEntityQuerySmall.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import AppIntents
import Foundation
import LemonCountdownModel
import SwiftData

public struct WidgetModelSmallEntityQuery: EntityQuery {
    public func entities(for identifiers: [UUID]) async throws -> [WidgetEntityQuerySmall] {
        return await WidgetModelHelper.fetchSmallWidget()
    }

    public func suggestedEntities() async throws -> [WidgetEntityQuerySmall] {
        return await WidgetModelHelper.fetchSmallWidget()
    }

    public func defaultResult() async -> WidgetEntityQuerySmall? {
        return nil
    }

    public init() {
    }
}

// Implementation of WidgetModelSmall
public struct WidgetEntityQuerySmall: AppEntity, EventInfoProvider {
    public static var defaultQuery: WidgetModelSmallEntityQuery {
        return WidgetModelSmallEntityQuery()
    }

    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return TypeDisplayRepresentation(name: "Small-sized Widget")
    }

    public var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: "\(widgetTitle)", subtitle: "\(eventTitle)")
    }

    public var id: UUID

    // widgetTemplateModel中的uuid
    public var widgetTemplateUUID: UUID

    // 标题
    public var widgetTitle: String
    // 事件标题
    public var eventTitle: String

    // 事件结束时间
    public var endDate: Date
    // 下一次的事件开始时间
    public var nextStartDate: Date
    // 下一次的事件结束时间
    public var nextEndDate: Date
    // 今天与下一次到期时间的间隔
    public var daysUntilNextStart: Int
    // 是否是重复事件
    public var isRepeatEnabled: Bool
    // 是否是全天事件
    public var isAllDayEvent: Bool

    public var jsonData: String

    public init(id: UUID = UUID(), widgetTemplateUUID: UUID, widgetTitle: String, eventTitle: String, endDate: Date, nextStartDate: Date, nextEndDate: Date, isRepeatEnabled: Bool, isAllDayEvent: Bool, jsonData: String) {
        daysUntilNextStart = Calendar.current.numberOfDaysBetween(Date(), and: nextEndDate)
        self.id = id
        self.widgetTemplateUUID = widgetTemplateUUID
        self.widgetTitle = widgetTitle
        self.eventTitle = eventTitle
        self.endDate = endDate
        self.nextStartDate = nextStartDate
        self.nextEndDate = nextEndDate
        self.isRepeatEnabled = isRepeatEnabled
        self.isAllDayEvent = isAllDayEvent
        self.jsonData = jsonData
    }
}

extension WidgetEntityQuerySmall: CustomStringConvertible {
    public var description: String {
        """
        WidgetEntityQuerySmall(
        id: \(id),
        widgetTitle: \(widgetTitle),
        eventTitle: \(eventTitle),
        endDate: \(endDate.formatted()),
        nextStartDate: \(nextStartDate.formatted()),
        nextEndDate: \(nextEndDate.formatted()),
        isRepeatEnabled: \(isRepeatEnabled),
        isAllDayEvent: \(isAllDayEvent),
        jsonData: \(jsonData)
        )
        """
    }
}

extension WidgetEntityQueryMedium: CustomStringConvertible {
    public var description: String {
        """
        WidgetEntityQueryMedium(
        id: \(id),
        widgetTitle: \(widgetTitle),
        eventTitle: \(eventTitle),
        endDate: \(endDate.formatted()),
        nextStartDate: \(nextStartDate.formatted()),
        nextEndDate: \(nextEndDate.formatted()),
        isRepeatEnabled: \(isRepeatEnabled),
        isAllDayEvent: \(isAllDayEvent),
        jsonData: \(jsonData)
        )
        """
    }
}

// extension WidgetEntityQueryLarge: CustomStringConvertible {
//    var description: String {
//        """
//        WidgetEntityQueryLarge(
//        id: \(id),
//        widgetTitle: \(widgetTitle),
//        eventTitle: \(eventTitle),
//        endDate: \(endDate.formatted()),
//        nextStartDate: \(nextStartDate.formatted()),
//        nextEndDate: \(nextEndDate.formatted()),
//        isRepeatEnabled: \(isRepeatEnabled),
//        isAllDayEvent: \(isAllDayEvent),
//        jsonData: \(jsonData)
//        )
//        """
//    }
// }
