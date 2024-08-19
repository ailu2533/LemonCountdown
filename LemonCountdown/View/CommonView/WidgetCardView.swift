//
//  WidgetCardView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import LemonCountdownModel
import SwiftMovable
import SwiftUI

struct WidgetCardView: View {
    var phase: WidgetPhase // Model containing data for the view
    var widgetSize: CGSize // Size of the widget

    // Initializer with default parameters and binding
    init(phase: WidgetPhase, widgetSize: CGSize) {
        self.phase = phase
        self.widgetSize = widgetSize
        Logging.widgetMeta.debug("WidgetCardView phase: \(phase)")
    }

    var body: some View {
        phase.background.backgroundView(widgetSize: widgetSize)
            .frame(width: widgetSize.width, height: widgetSize.height) // Set the size

            .overlay {
                ZStack {
                    // Configuration for movable objects (stickers, texts, event info)
                    let stickerConfig = MovableObjectViewConfig(enable: false, deleteCallback: { item in
                        phase.stickers.removeAll { $0.id == item.id }
                    })

                    let textConfig = MovableObjectViewConfig(parentSize: widgetSize, enable: false, deleteCallback: { item in
                        phase.texts.removeAll { $0.id == item.id }
                    })

                    let eventInfoConfig = MovableObjectViewConfig(parentSize: widgetSize, enable: false, deleteCallback: { item in
                        phase.eventInfo.removeAll { $0.id == item.id }
                    })

                    // Display movable views for stickers
                    ForEach(phase.stickers) { sticker in
                        MovableObjectView(item: sticker, selection: .constant(nil), config: stickerConfig) { item in
                            Image(item.stickerName)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }

                    // Display movable views for texts
                    ForEach(phase.texts) { text in
                        MovableObjectView(item: text, selection: .constant(nil), config: textConfig) { item in
                            item.view()
                        }
                    }

                    // Iterates over each eventInfo object in the model's eventInfo array
                    ForEach(phase.eventInfo) { eventInfo in
                        MovableObjectView(item: eventInfo, selection: .constant(nil), config: eventInfoConfig) { _ in
                            EventInfoView(eventInfoType: eventInfo.eventInfoType, eventInfoProvider: eventInfo.getEventInfoProvider(), fontName: eventInfo.fontName, fontSize: eventInfo.fontSize, color: eventInfo.color)
                        }
                    }
                }
            }
    }
}

extension WidgetCardView: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.phase.hashValue == rhs.phase.hashValue
    }
}
