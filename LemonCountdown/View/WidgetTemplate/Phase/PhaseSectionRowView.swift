//
//  PhaseSectionView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
import LemonUtils
import SwiftUI

// MARK: - Phase Section View

/// Represents a view for displaying and interacting with a phase of a widget template.
struct PhaseSectionRowView: View {
    let config: PhaseSectionRowConfiguration
    @Bindable var phase: WidgetPhase
    @State private var showSheet = false

    @State private var showFullScreen = false

    var body: some View {
        VStack {
            Button {
                showFullScreen = true
            } label: {
                ZStack {
                    WidgetCardView(phase: phase, widgetSize: config.widgetSize)
                        .roundedWidget()
                        .disabled(false)
                    Color.white.opacity(0.01)
                }
            }.buttonStyle(PlainButtonStyle())

            if config.showTime {
                timeDisplay
            }
        }.frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: $showSheet, content: {
                phaseTimeEditor
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            })
            .fullScreenCover(isPresented: $showFullScreen) {
                WidgetPhaseEditorView(phase: phase, widgetSize: config.widgetSize)
            }
    }

    @ViewBuilder
    private var phaseTimeEditor: some View {
        if config.useRelativeTimeEditor {
            relativePhaseTimeEditor
        } else {
            absolutePhaseTimeEditor
        }
    }

    @ViewBuilder
    private var absolutePhaseTimeEditor: some View {
        if let startDate = config.startDate, let endDate = config.endDate {
            AbsolutePhaseTimeEditor(startDate: startDate,
                                    endDate: endDate,
                                    leftTimeOffset: config.prevEndTimeOffset,
                                    rightTimeOffset: getRightTimeOffset(startDate, endDate, config.nextEndTimeOffset),
                                    currentPhaseEndTimeOffset: $phase.phaseTimeRule.endTimeOffset_)
        } else {
            Text("ERROR")
        }
    }

    func getRightTimeOffset(_ startDate: Date, _ endDate: Date, _ nextEndTimeOffset: TimeOffset) -> TimeOffset {
        if !nextEndTimeOffset.isMax {
            return nextEndTimeOffset
        }

        return TimeOffset(second: Int(startDate.distance(to: endDate)))
    }

    @ViewBuilder
    private var timeDisplay: some View {
        HStack {
            Text(timeDisplayText)
            Spacer()
            Button(action: {
                showSheet = true
            }, label: {
                Text(timeDisplayButtonLabel)
            }).buttonStyle(BorderedButtonStyle())
                .disabled(config.isLastRowInSection)
        }
    }

    private var timeDisplayText: String {
        if config.useRelativeTimeEditor {
            return config.prevEndTimeOffset.text
        }
        return formattedTime(for: config.prevEndTimeOffset)
    }

    private var timeDisplayButtonLabel: String {
        if config.useRelativeTimeEditor {
            return phase.phaseTimeRule.endTimeOffset_.text
        }
        return formattedTime(for: phase.phaseTimeRule.endTimeOffset_)
    }

    private func formattedTime(for timeOffset: TimeOffset) -> String {
        if timeOffset.isMax {
            return config.endDate!.customFormatted()
        }
        return config.startDate!.addingTimeInterval(timeOffset.toTimeInterval()).customFormatted()
    }

    @ViewBuilder
    private var relativePhaseTimeEditor: some View {
        let currentDate = Date()
        let date = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: currentDate)!
        let startDate = date.addingTimeInterval(config.prevEndTimeOffset.toTimeInterval())
        let endDate = date.addingTimeInterval(phase.phaseTimeRule.endTimeOffset)
//
//        Text("如果事件开始时间���\(date.formatted(date: .abbreviated, time: .shortened))，那么这个画面将在\(startDate.formatted(date: .abbreviated, time: .shortened))到\(endDate.formatted(date: .abbreviated, time: .shortened))之间显示")
//            .font(.caption)
//            .foregroundStyle(.secondary)
//            .padding(.horizontal)

        if config.prevEndTimeOffset.isMax {
            Text("请修改上一个画面的结束时间，否则此画面将不会显示")
                .foregroundStyle(.red)
        }

        if !phase.phaseTimeRule.endTimeOffset_.isMax && endDate <= startDate {
            Text("时间不符合规则, 此画面的开始时间应该大于上一个画面的结束时间").foregroundStyle(.red)
        }

        TimeOffsetPickerView(timeOffset: $phase.phaseTimeRule.endTimeOffset_, units: [.hour, .minute])
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
    }
}

struct AbsolutePhaseTimeEditor: View {
    var startDate: Date
    var endDate: Date
    var leftTimeOffset: TimeOffset
    var rightTimeOffset: TimeOffset

    @Binding var currentPhaseEndTimeOffset: TimeOffset

    @State private var date: Date = .now

    private func computeDate(using timeOffset: TimeOffset, relativeTo baseDate: Date) -> Date {
        timeOffset.isMax ? endDate : baseDate.addingTimeInterval(timeOffset.toTimeInterval())
    }

    var body: some View {
        let leftDate = computeDate(using: leftTimeOffset, relativeTo: startDate)
        let rightDate = computeDate(using: rightTimeOffset, relativeTo: startDate)

        VStack {
            Section {
                LabeledContent("最小时间") {
                    Text(leftDate.customFormatted())
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 2)

                LabeledContent("最大时间") {
                    Text(rightDate.customFormatted())
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 2)
            }
            .padding(.horizontal)
            .background(Color(.systemBackground))
            // .cornerRadius(10)
            // .shadow(radius: 3)

            Section {
                DatePicker("",
                           selection: $date,
                           in: leftDate ... max(leftDate, rightDate),
                           displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .datePickerStyle(.wheel)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .onChange(of: date) { _, newDate in
                        currentPhaseEndTimeOffset = TimeOffset(second: Int(startDate.distance(to: newDate)), isMax: false)
                    }
            }
            .padding(.horizontal)
        }
        .padding()
        // .background(Color(.secondarySystemBackground))
        // .cornerRadius(12)
        // .shadow(radius: 5)
    }
}
