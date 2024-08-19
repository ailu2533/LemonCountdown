//
//  AbsolutePhaseTimeEditor.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonDateUtils

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
