//
//  PhaseSectionView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
import LemonUtils
import SwiftUI
import SwiftWidgetEditorKit

// MARK: - Phase Section View

/// Represents a view for displaying and interacting with a phase of a widget template.
struct PhaseSectionRowView: View {
    let config: PhaseSectionRowConfiguration
    @Bindable var phase: WidgetPhase
    @State private var showSheet = false
    @State private var showFullScreen = false

    var body: some View {
        VStack {
            WidgetButton(phase: phase, widgetSize: config.widgetSize, showFullScreen: $showFullScreen)

            if config.showTime {
                TimeDisplayView(config: config, phase: phase, showSheet: $showSheet)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .sheet(isPresented: $showSheet) {
            PhaseTimeEditorView(config: config, phase: phase)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            WidgetPhaseEditorView(phase: phase, widgetSize: config.widgetSize) {
                _ in
                print("TODO")
            }
        }
    }
}
