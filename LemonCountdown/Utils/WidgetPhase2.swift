//
//  WidgetPhase2.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
// import LemonUtils
import SwiftUI

@Observable
class WidgetPhase: Identifiable, Codable {
    var id = UUID()

    var timeOffset: TimeOffset = .init()
    var stickers: [MovableSticker] = []
    var texts: [TextItem] = []
    var eventInfo: [EventInfo] = []
    var backgroundColor: Color = .clear

    enum CodingKeys: String, CodingKey {
        case timeOffset, stickers, texts, eventInfo, backgroundColor
    }

    init(stickers: [MovableSticker] = [], texts: [TextItem] = [], eventInfo: [EventInfo] = [], backgroundColor: Color = .clear) {
        self.stickers = stickers
        self.texts = texts
        self.eventInfo = eventInfo
        self.backgroundColor = backgroundColor
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timeOffset = try container.decode(TimeOffset.self, forKey: .timeOffset)
        stickers = try container.decode([MovableSticker].self, forKey: .stickers)
        texts = try container.decode([TextItem].self, forKey: .texts)
        eventInfo = try container.decode([EventInfo].self, forKey: .eventInfo)
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeOffset, forKey: .timeOffset)
        try container.encode(stickers, forKey: .stickers)
        try container.encode(texts, forKey: .texts)
        try container.encode(eventInfo, forKey: .eventInfo)
        try container.encode(backgroundColor, forKey: .backgroundColor)
    }

    func view() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(lineWidth: 1.0)
                .background(backgroundColor.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .overlay {
                    ZStack {
                        ForEach(stickers) { sticker in
                            MovableObjectView2(textItem: sticker, selection: .constant(nil)) { item in
                                Image(item.stickerName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        ForEach(texts) { text in
                            MovableObjectView2(textItem: text, selection: .constant(nil)) { item in
                                item.view()
                            }
                        }
                    }
                }
        }
    }
}

extension WidgetPhase: Hashable {
    static func == (lhs: WidgetPhase, rhs: WidgetPhase) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(stickers)
        hasher.combine(texts)
        hasher.combine(eventInfo)
        hasher.combine(backgroundColor)
    }
}
