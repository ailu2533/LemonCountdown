//
//  WidgetButton.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonCountdownModel

// MARK: - WidgetButton

struct WidgetButton: View {
    let phase: WidgetPhase
    let widgetSize: CGSize
    @Binding var showFullScreen: Bool

    var body: some View {
        Button {
            showFullScreen = true
        } label: {
            ZStack {
                WidgetCardView(phase: phase, widgetSize: widgetSize)
                    .roundedWidget()
                    .disabled(false)
                Color.white.opacity(0.01)
            }
        }.buttonStyle(PlainButtonStyle())
    }
}
