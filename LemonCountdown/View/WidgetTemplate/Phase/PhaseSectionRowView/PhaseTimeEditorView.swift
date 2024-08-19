//
//  PhaseTimeEditorView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftUI

// MARK: - PhaseTimeEditorView

struct PhaseTimeEditorView: View {
    let config: PhaseSectionRowConfiguration
    @Bindable var phase: WidgetPhase

    var body: some View {
        Group {
            if config.useRelativeTimeEditor {
                RelativePhaseTimeEditorView(config: config, phase: phase)
            } else {
                AbsolutePhaseTimeEditorView(config: config, phase: phase)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
