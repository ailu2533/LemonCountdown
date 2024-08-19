//
//  AllDaySectionView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftUI

struct AllDaySectionView: View {
    @Bindable var cb: EventBuilder

    var body: some View {
        Section {
            Toggle("全天", isOn: Binding(get: {
                cb.isAllDayEvent
            }, set: { newValue in
                cb.isAllDayEvent = newValue
                cb.firstNotification = .none
                cb.secondNotification = .none

                if newValue {
                    cb.adjustDate()
                }
            }))

            DatePicker("目标日期", selection: $cb.startDate, displayedComponents: [.date])
                .onChange(of: cb.startDate) { _, newValue in
                    let endDateComponents = Calendar.current.dateComponents([.hour, .minute], from: cb.endDate)
                    cb.endDate = Calendar.current.date(bySettingHour: endDateComponents.hour!, minute: endDateComponents.minute!, second: 0, of: newValue)!
                }

            if !cb.isAllDayEvent {
                DatePicker("开始时间", selection: $cb.startDate, displayedComponents: [.hourAndMinute])
                DatePicker("结束时间", selection: $cb.endDate, displayedComponents: [.hourAndMinute])
            }
        }
    }
}
