//
//  TimerView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct EventTimerView: View {
    var nextDate: Date
    let fontSize: CGFloat
    let color: Color
    let fontName = "DigitalDismay"
    let backgroundOpacity = 0.15

    init(nextDate: Date?, fontSize: CGFloat = 35.0, color: Color = Color.black) {
        self.nextDate = nextDate ?? Date()

        if self.nextDate <= Date() {
            self.nextDate = Date()
        }

        if Date().distance(to: self.nextDate) >= 24 * 60 * 60 {
            self.nextDate = Date().addingTimeInterval(24 * 60 * 60)
        }

        self.fontSize = fontSize
        self.color = color
    }

    var body: some View {
        Text("88:88:88")
            .multilineTextAlignment(.trailing)
            .font(.custom(fontName, size: fontSize))
            .foregroundStyle(color)
            .opacity(backgroundOpacity)
            .overlay(alignment: .trailing) {
                Text(nextDate, style: .timer)
                    .multilineTextAlignment(.trailing)
                    .font(.custom(fontName, size: fontSize))
                    .foregroundStyle(color)
            }
    }
}

#Preview {
    EventTimerView(nextDate: Date())
}
