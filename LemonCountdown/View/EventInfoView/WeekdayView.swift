//
//  WeekdayView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct WeekdayView: View {
    let fontSize: CGFloat
    let color: Color
    let fontName: String?

    init(
        fontSize: CGFloat = 25.0,
        color: Color = Color.black,
        fontName: String? = nil) {
        self.fontSize = fontSize
        self.color = color
        self.fontName = fontName
    }

    var body: some View {
        Text(getWeekday())
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
            .foregroundStyle(color)
    }

    func getWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}

#Preview {
    WeekdayView()
}
