//
//  EventInfoView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/5.
//

import LemonCountdownModel
import SwiftUI

public struct EventInfoView: View {
    private var eventInfoKind: EventInfoKind
    private var eventInfoProvider: EventInfoProvider?
    private var fontName: String?
    private var fontSize: CGFloat
    private var color: Color

    public init(eventInfoType: EventInfoKind,
                eventInfoProvider: EventInfoProvider? = nil,
                fontName: String? = nil,
                fontSize: CGFloat,
                color: Color) {
        eventInfoKind = eventInfoType
        self.eventInfoProvider = eventInfoProvider
        self.fontName = fontName
        self.fontSize = fontSize
        self.color = color
    }

    public var body: some View {
        switch eventInfoKind {
        case .daysUntilEvent:
            DaysUntilEventView(daysUntilEvent: eventInfoProvider?.daysUntilNextStart, fontSize: fontSize, color: color, fontName: fontName)

        case .eventStartDate:
            EventStartDate(startDate: eventInfoProvider?.nextStartDate, fontSize: fontSize, color: color, fontName: fontName)

        case .eventTitle:
            EventTitleView(title: eventInfoProvider?.eventTitle, fontSize: fontSize, color: color, fontName: fontName)

        case .currentWeekDay:
            WeekdayView(fontSize: fontSize, color: color, fontName: fontName)

        case .daysSinceEvent:
            DaysSinceEventView(daysSinceEvent: daysSinceEvent(), fontSize: fontSize, color: color, fontName: fontName)

        case .timeUntilEventStart:
            EventTimerView(nextDate: eventInfoProvider?.nextStartDate, fontSize: fontSize, color: color)

        case .timeUntilEventEnd:
            // Calculate and display the time until the event ends
            EventTimerView(nextDate: eventInfoProvider?.nextEndDate, fontSize: fontSize, color: color)
        }
    }

    // 计算事情已经过去多少天了
    func daysSinceEvent() -> Int {
        if let eventInfoProvider {
            let days = Calendar.current.numberOfDaysBetween(eventInfoProvider.nextStartDate, and: Date())

            // 事情还没有过去
            if days <= 0 {
                return 0
            }

            return days
        }

        // 占位数据
        return 88
    }
}
