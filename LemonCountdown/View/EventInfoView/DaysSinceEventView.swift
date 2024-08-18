//
//  DaysSinceEventView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct DaysSinceEventView: View {
    let daysSinceEvent: Int
    let fontSize: CGFloat
    let color: Color
    let fontName: String?

    init(daysSinceEvent: Int = 10,
         fontSize: CGFloat = 25.0,
         color: Color = Color.black,
         fontName: String? = nil) {
        self.daysSinceEvent = daysSinceEvent
        self.fontSize = fontSize
        self.color = color
        self.fontName = fontName
    }

    var body: some View {
        Text("+\(daysSinceEvent)天")
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
            .foregroundStyle(color)
    }
}

#Preview {
    DaysSinceEventView()
}
