//
//  RepeatSectionView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonCountdownModel

struct RepeatSectionView: View {
    @Bindable var cb: EventBuilder

    var body: some View {
        Section {
            Toggle("重复", isOn: $cb.isRepeatEnabled)
            if cb.isRepeatEnabled {
                NavigationLink {
                    RepeatPickerView(recurrenceType: $cb.recurrenceType, repeatPeriod: $cb.repeatPeriod, repeatInterval: $cb.repeatInterval, customWeek: $cb.repeatCustomWeekly)
                } label: {
                    Text(repeatText(recurrenceType: cb.recurrenceType, repeatPeriod: cb.repeatPeriod, repeatInterval: cb.repeatInterval))
                }

                if cb.recurrenceType == .customWeekly {
                    Text(repeatTextCustomWeekly(repeatCustomWeekly: cb.repeatCustomWeekly))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Toggle("结束重复", isOn: $cb.hasRepeatEndDate)
                if cb.hasRepeatEndDate {
                    DatePicker("结束日期", selection: Binding(get: {
                        cb.repeatEndDate ?? .now
                    }, set: { value in
                        cb.repeatEndDate = value
                    }), in: max(cb.startDate, cb.endDate)..., displayedComponents: .date)
                }
            }
        }
    }
}
