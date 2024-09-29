//
//  EventBackupView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftUI

struct EventBackupView: View {
    let eventBackup: EventBackupModel
    var body: some View {
        Form {
            Section {
                LabeledContent("标题") {
                    Text(eventBackup.title)
                }

                LabeledContent("目标日期") {
                    Text(eventBackup.startDate.formatted(date: .abbreviated, time: .omitted))
                }

                if !eventBackup.isAllDayEvent {
                    LabeledContent("开始时间") {
                        Text(eventBackup.startDate.customFormatted())
                    }

                    LabeledContent("结束时间") {
                        Text(eventBackup.endDate.customFormatted())
                    }
                }
            }

            // 重复规则
            if eventBackup.isRepeatEnabled {
                // TODO:

                switch eventBackup.recurrenceType {
                case .singleCycle:
                    Text(repeatText(recurrenceType: eventBackup.recurrenceType, repeatPeriod: eventBackup.repeatPeriod, repeatInterval: eventBackup.repeatInterval))
                case .customWeekly:

                    Text("自定义每周重复")

                    Text(repeatTextCustomWeekly(repeatCustomWeekly: eventBackup.repeatCustomWeekly))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let repeatEndDate = eventBackup.repeatEndDate {
                    LabeledContent("重复结束时间") {
                        Text(repeatEndDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            } else {
                Text("不重复")
            }

            Section {
                Text("创建小组件时，系统会复制绑定的事件。即使后续修改或删除原事件，也不会影响已创建的小组件。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.listRowBackground(Color(.clear))
                .listSectionSpacing(6)
        }
    }
}
