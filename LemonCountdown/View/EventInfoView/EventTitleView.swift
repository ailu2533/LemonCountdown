//
//  EventTitleView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import SwiftUI

struct EventTitleView: View {
    let title: String
    let fontSize: CGFloat
    let color: Color
    var fontName: String?

    init(title: String?,
         fontSize: CGFloat = 25.0,
         color: Color = Color.black,
         fontName: String? = nil) {
        self.title = title ?? String(localized: "标题占位")
        self.fontSize = fontSize
        self.color = color
        self.fontName = fontName
    }

    var body: some View {
        Text(title)
            .font(fontName == nil ? .system(size: fontSize) : .custom(fontName!, size: fontSize))
            .foregroundStyle(color)
    }
}

#Preview {
    EventTitleView(title: nil)
}
