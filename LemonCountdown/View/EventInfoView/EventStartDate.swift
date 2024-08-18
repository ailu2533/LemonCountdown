//
//  EventStartDate.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct EventStartDate: View {
    let startDate: Date
    let fontSize: CGFloat
    let color: Color
    let fontName: String?

    init(startDate: Date?,
         fontSize: CGFloat = 25.0,
         color: Color = Color.black,
         fontName: String? = nil) {
        self.startDate = startDate ?? Date()
        self.fontSize = fontSize
        self.color = color
        self.fontName = fontName
    }

    var body: some View {
        Text(startDate.formatted(date: .abbreviated, time: .omitted))
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
            .foregroundStyle(color)
    }
}

#Preview {
    EventStartDate(startDate: nil)
}
