//
//  WidgetCard2.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/25.
//

import LemonCountdownModel
import LemonUtils
import SwiftMovable
import SwiftUI

@Observable
class DraggingState {
    var isDragging = false
}

struct EditableWidgetCardView: View {
    var phase: WidgetPhase // Model containing data for the view
    var widgetSize: CGSize // Size of the widget
    var enableModify: Bool // Flag to enable modification of the widget elements
//    var fillStyle: AnyShapeStyle // The fill style for the widget background


    @Binding var selected: UUID? // Currently selected movable object

    let coordinateSpaceId = UUID()

    // Initializer with default parameters and binding
    init(model: WidgetPhase, widgetSize: CGSize, enableModify: Bool = true, selected: Binding<UUID?> = .constant(nil)) {
//        Logging.widgetPreview.debug("WidgetCardView \(model.description)")
        phase = model
        self.widgetSize = widgetSize
        self.enableModify = enableModify
//        background = background
        _selected = selected // Initialize the binding property
    }

    var body: some View {
        phase.background.backgroundView(widgetSize: widgetSize)
            .frame(width: widgetSize.width, height: widgetSize.height) // Set the size
            .roundedWidget()
            .onTapGesture {
                selected = nil // Deselect any selected object on tap
            }
//            .coordinateSpace(name: coordinateSpaceId)
            .overlay {
                ZStack {
                    // Configuration for movable objects (stickers, texts, event info)
                    let stickerConfig = MovableObjectViewConfig(parentSize: widgetSize, enable: enableModify, deleteCallback: { item in
                        phase.stickers.removeAll { $0.id == item.id }
                        selected = nil
                    })

                    let textConfig = MovableObjectViewConfig(parentSize: widgetSize, enable: enableModify, deleteCallback: { item in
                        phase.texts.removeAll { $0.id == item.id }
                        selected = nil
                    })

                    let eventInfoConfig = MovableObjectViewConfig(parentSize: widgetSize, enable: enableModify, deleteCallback: { item in
                        phase.eventInfo.removeAll { $0.id == item.id }
                        selected = nil
                    })

                    // Display movable views for stickers
                    ForEach(phase.stickers) { sticker in
                        MovableObjectView(item: sticker, selection: $selected, config: stickerConfig) { item in
                            Image(item.stickerName)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }

                    // Display movable views for texts
                    ForEach(phase.texts) { text in
                        MovableObjectView(item: text, selection: $selected, config: textConfig) { item in
                            item.view()
                        }
                    }

                    // Iterates over each eventInfo object in the model's eventInfo array
                    ForEach(phase.eventInfo) { eventInfo in
                        // Checks if there is a countModelProtocol available in the model
                        // If no countModelProtocol is available, it directly uses the eventInfo as is
                        MovableObjectView(item: eventInfo, selection: $selected, config: eventInfoConfig) { _ in
                            // Similarly, the view for the eventInfo is generated here
//                            item.textView()
                            EventInfoView(eventInfoType: eventInfo.eventInfoType, eventInfoProvider: eventInfo.getEventInfoProvider(), fontName: eventInfo.fontName, fontSize: eventInfo.fontSize, color: eventInfo.color)
                        }
                    }
                }
            }

            .sensoryFeedback(.selection, trigger: selected) { _, newValue in
                if newValue == nil {
                    return false
                }

                return true
            }
    }
}
