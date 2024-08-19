//
//  RepeatPickerView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import HorizontalPicker
import LemonDateUtils
import LemonUtils
import SwiftUI
struct RepeatPickerView: View {
    @Binding var recurrenceType: RecurrenceType
    @Binding var repeatPeriod: RepeatPeriod
    @Binding var repeatInterval: Int
    @Binding var customWeek: UInt8

    @State private var weekBits = Array(repeating: false, count: 7)

    var body: some View {
        Form {
            Picker("重复类型", selection: $recurrenceType) {
                Text("周期重复").tag(RecurrenceType.singleCycle)
                Text("自定义每周重复").tag(RecurrenceType.customWeekly)
            }

            Section {
                switch recurrenceType {
                case .singleCycle:
                    RepeatPeriodPickerView(repeatPeriod: $repeatPeriod, repeatN: $repeatInterval)
                        .padding(.top, 20)

                case .customWeekly:

                    List {
                        ForEach(weekDays.indices, id: \.self) { index in
                            Toggle(weekDays[index].0, isOn: Binding(get: {
                                weekBits[index]
                            }, set: { newValue in
                                if newValue {
                                    weekBits[index] = true
                                } else {
                                    // 只有当至少有两个 true 时，才允许将当前的 true 设置为 false
                                    if weekBits.filter({ $0 }).count > 1 {
                                        weekBits[index] = false
                                    }
                                }
                            }))
                            .toggleStyle(CheckToggleStyle())
                        }
                    }
                }
            }
        }
//        .padding(.vertical, 10)
        .onAppear {
            if customWeek == 0 {
                customWeek = 1
            }
            // 将 customWeek 转换为 weekBits
            weekBits = (0 ..< 7).map { index in
                (customWeek & (1 << index)) != 0
            }
        }
        .onDisappear {
            customWeek = weekBits.enumerated().reduce(0) { result, pair in
                let (index, isSet) = pair
                return isSet ? result | (1 << index) : result
            }
        }
    }
}

public func repeatText(recurrenceType: RecurrenceType, repeatPeriod: RepeatPeriod, repeatInterval: Int) -> LocalizedStringKey {
    switch recurrenceType {
    case .singleCycle:

        if repeatInterval == 1 {
            switch repeatPeriod {
            case .daily:
                return "每天重复一次"
            case .weekly:
                return "每周重复一次"

            case .monthly:
                return "每月重复一次"
            case .yearly:
                return "每年重复一次"
            }
        } else {
            switch repeatPeriod {
            case .daily:
                return "每\(repeatInterval)天重复一次"
            case .weekly:
                return "每\(repeatInterval)周重复一次"
            case .monthly:
                return "每\(repeatInterval)个月重复一次"
            case .yearly:
                return "每\(repeatInterval)年重复一次"
            }
        }

    case .customWeekly:
        return "自定义每周重复"
    }
}



public func repeatTextCustomWeekly(repeatCustomWeekly: UInt8) -> String {
    var daysActive = [String]()

    for i in 0 ..< localizedWeekDays.count {
        if (repeatCustomWeekly & (1 << i)) != 0 {
            daysActive.append(localizedWeekDays[i])
        }
    }

    if daysActive.isEmpty {
        return String(localized: "不重复")
    }
    if daysActive.count == 7 {
        return String(localized: "每天重复")
    }
    return daysActive.joined(separator: " ")
}
