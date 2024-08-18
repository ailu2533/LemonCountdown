//
//  LargeProvider.swift
//  WidgetsExtension
//
//  Created by ailu on 2024/5/14.
//

import SwiftData
import SwiftUI
import WidgetKit

// struct LargeProvider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> LargeEntry {
//        LargeEntry(date: Date(), configuration: LargeConfigurationAppIntent(), widgetTemplateId: nil)
//    }
//
//    func snapshot(for configuration: LargeConfigurationAppIntent, in context: Context) async -> LargeEntry {
//        LargeEntry(date: Date(), configuration: configuration, widgetTemplateId: nil)
//    }
//
//    func timeline(for configuration: LargeConfigurationAppIntent, in context: Context) async -> Timeline<LargeEntry> {
//        let nextRefreshDate = Date().offset(.day, value: 1)!.adjust(for: .startOfDay)!
//
//        Logging.provider.info("\(configuration.event?.eventTitle ?? "no event")")
//        if let event = configuration.event {
//            let widgetTemplate = decodeWidgetTemplate(event.jsonData)
//            Logging.provider.info("widgetTemplate: \(widgetTemplate.phases)")
//
//            let entries = generateEntries(for: configuration, event: event, widgetTemplate: widgetTemplate)
//
//            return Timeline(entries: entries, policy: .after(nextRefreshDate))
//        }
//
//        return Timeline(entries: [LargeEntry(date: Date(), configuration: .init())], policy: .after(nextRefreshDate))
//    }
//
//    // 生成 Entries
//    func generateEntries(for configuration: LargeConfigurationAppIntent, event: WidgetEntityQueryLarge, widgetTemplate: WidgetTemplate) -> [LargeEntry] {
//        // 获取当前日期
//        let currentDate = Date()
//        // 获取倒计时的开始日期
//        let startDate = event.nextStartDate
//        // 获取倒计时的结束日期
//        let endDate = event.nextEndDate
//        // 检查事件是否为全天事件
//        let isAllDayEvent = event.isAllDayEvent
//
//        // 尝试将开始日期和结束日期调整到对应的一天的开始和结束
//        guard let nextStartDateStartOfDay = startDate.adjust(for: .startOfDay),
//              let endDateEndOfDay = endDate.adjust(for: .endOfDay) else {
//            // 如果日期调整失败，返回空数组
//            return []
//        }
//
//        // 初始化一个空数组来存储条目
//        var entries: [LargeEntry] = []
//
//        // 添加条目的辅助函数
//        func addEntry(date: Date, phase: WidgetPhase?) {
//            // 只有当阶段存在时才添加条目
//            if let phase = phase {
//                entries.append(LargeEntry(date: date, configuration: configuration, widgetTemplateId: nil, phase: phase))
//            }
//        }
//
//        // 根据当前日期与开始日期的关系，决定是否添加第一个阶段
//        if currentDate < nextStartDateStartOfDay {
//            // 添加目标日期之前的阶段
//            addEntry(date: currentDate, phase: widgetTemplate.phasesBeforeStartDate.first)
//        }
//
//        // 如果事件不是全天事件，并且开始日期的当天早于开始时间
//        if !isAllDayEvent && nextStartDateStartOfDay < startDate {
//            // 添加开始日期到开始时间之间的阶段
//            addEntry(date: nextStartDateStartOfDay, phase: widgetTemplate.phasesBetweenStartAndStartTime.first)
//        }
//
//        // 处理开始时间和结束时间之间的多个阶段
//        var lastEnd = startDate
//        for phase in widgetTemplate.phases {
//            // 为每个阶段添加条目
//
//            // 结束时间已经达到或超过了事件的结束日期，则停止添加新的阶段
//            if lastEnd >= endDate {
//                break
//            }
//
//            addEntry(date: lastEnd, phase: phase)
//            // 更新最后的结束时间
//            lastEnd = startDate.offset(.second, value: Int(phase.phaseTimeRule.endTimeOffset))!
//        }
//
//        // 23:59当做当天的最大时间
//        let realEndDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: endDate)!
//
//        // 如果事件不是全天事件，并且结束时间早于结束日期的当天结束
//        if !isAllDayEvent && endDate < realEndDate {
//            // 添加结束时间到结束日期之间的阶段
//            addEntry(date: endDate, phase: widgetTemplate.phasesBetweenEndTimeAndEndDate.first)
//        }
//
//        // 如果事件不是重复事件
//        if !event.isRepeatEnabled {
//            // 添加结束日期后的阶段
//            addEntry(date: endDateEndOfDay, phase: widgetTemplate.phasesAfterStartDate.first)
//        }
//
//        // 绑定事件信息到每个条目的阶段
//        entries.forEach { entry in
//            entry.phase?.setEventInfoProvider(event)
//        }
//
////        // 过滤策略
////        // 找到最后一个 date小于等于当前时间的条目x，过滤 x 之前的条目
////        let lastEntry = entries.last(where: { $0.date <= currentDate })
////        if let index = entries.firstIndex(where: { $0.date == lastEntry?.date }) {
////            entries = Array(entries[index...])
////        }
//        // 记录生成的条目信息，用于调试
//        Logging.widgetEntries.debug("\(entries)")
//
//        // 返回生成的条目数组
//        return entries
//    }
// }
