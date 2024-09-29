//
//  WidgetCardView3.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import LemonUtils
import SwiftMovable
import SwiftUI

// New subviews
struct WidgetPhaseEditorCardView: View {
    let phase: WidgetPhase
    let widgetSize: CGSize
    @Binding var selection: MovableObject?

//    @Binding var selectedMovableObjectUUID: UUID?

//    var draggingState = DraggingState()
    init(phase: WidgetPhase, widgetSize: CGSize, selection: Binding<MovableObject?>) {
        self.phase = phase
        self.widgetSize = widgetSize
        _selection = selection
    }

    @State var highlightX: Bool = false
    @State var highlightY: Bool = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .onTapGesture {
                    selection = nil
                }
            EditableWidgetCardView(model: phase, widgetSize: widgetSize, selection: $selection)
                .overlayPreferenceValue(ViewSizeKey.self) { preferences in
                    GeometryReader { geometry in
                        preferences.map {
                            Color.clear
                                .onChange(of: geometry[$0]) { _, newValue in
                                    highlightX = (abs(newValue.x - widgetSize.width / 2) <= 3)
                                    highlightY = (abs(newValue.y - widgetSize.height / 2) <= 3)
                                }
                        }
                    }
                }
                .sensoryFeedback(.impact(flexibility: .rigid, intensity: 0.5), trigger: highlightX, condition: { oldValue, newValue in
                    !oldValue && newValue && selection != nil
                })
                .sensoryFeedback(.impact(flexibility: .rigid, intensity: 0.5), trigger: highlightY, condition: { oldValue, newValue in
                    !oldValue && newValue && selection != nil
                })
//                .overlay(content: {
//                    Line().stroke(lineWidth: 1.0).frame(width: widgetSize.width, height: 1)
//                        .foregroundStyle(Color.chineseRed)
//                        .opacity(highlightY && draggingState.isDragging ? 1 : 0)
//                    Line().stroke(lineWidth: 1.0).frame(width: widgetSize.height, height: 1)
//                        .foregroundStyle(Color.chineseRed)
//                        .rotationEffect(.degrees(90))
//                        .opacity(highlightX && draggingState.isDragging ? 1 : 0)
//                })
        }
//        .environment(draggingState)
    }
}
