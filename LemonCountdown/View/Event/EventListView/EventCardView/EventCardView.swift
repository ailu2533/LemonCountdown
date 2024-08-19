//
//  CardView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/2.
//

import SwiftUI

// MARK: - EventCardView

struct EventCardView: View {
    // MARK: - Properties

    private let icon: String
    private let title: String
    private let diffDays: Int
    private let color: Color
    private let isRepeat: Bool
    private let enableNotification: Bool
    // 时间的下一次开始日期
    private let eventStartDate: Date

    private var cornerRadius: CGFloat = 25

    // MARK: - Initialization

    init(icon: String, title: String, diffDays: Int, colorHex: String, eventStartDate: Date, isRepeat: Bool = false, enableNotification: Bool = false) {
        self.icon = icon
        self.title = title
        self.diffDays = diffDays
        color = Color(hex: colorHex)!
        self.eventStartDate = eventStartDate
        self.isRepeat = isRepeat
        self.enableNotification = enableNotification
    }

    // MARK: - Body

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.horizontal, 10)

            VStack(alignment: .leading) {
                Text(title)
                Text(eventStartDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(eventStartDate.formatted(Date.FormatStyle().weekday(.wide)))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            EventDayView(event: diffDays)
                .padding(.trailing, 10)
        }
        .frame(height: 100)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(radius: 1)
    }
}
