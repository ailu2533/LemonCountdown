//
//  DaysUntilEventView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct DaysUntilEventView: View {
    let daysUntilEvent: Int
    let fontSize: CGFloat
    let color: Color
    let fontName: String?

    init(daysUntilEvent: Int?,
         fontSize: CGFloat = 25.0,
         color: Color = Color.black,
         fontName: String? = nil) {
        self.daysUntilEvent = daysUntilEvent ?? 10
        self.fontSize = fontSize
        self.color = color
        self.fontName = fontName
    }

    var body: some View {
        Text("\(daysUntilEvent)天")
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
            .foregroundStyle(color)
    }
}

#Preview {
    DaysUntilEventView(daysUntilEvent: 10)
}
