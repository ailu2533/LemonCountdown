//
//  AbsolutePhaseTimeEditorView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
import SwiftUI

// MARK: - AbsolutePhaseTimeEditorView

struct AbsolutePhaseTimeEditorView: View {
    let config: PhaseSectionRowConfiguration
    @Bindable var phase: WidgetPhase

    var body: some View {
        if let startDate = config.startDate, let endDate = config.endDate {
            AbsolutePhaseTimeEditor(startDate: startDate,
                                    endDate: endDate,
                                    leftTimeOffset: config.prevEndTimeOffset,
                                    rightTimeOffset: getRightTimeOffset(startDate, endDate, config.nextEndTimeOffset),
                                    currentPhaseEndTimeOffset: $phase.phaseTimeRule.endTimeOffset_)
        } else {
            Text("ERROR")
        }
    }

    private func getRightTimeOffset(_ startDate: Date, _ endDate: Date, _ nextEndTimeOffset: TimeOffset) -> TimeOffset {
        if !nextEndTimeOffset.isMax {
            return nextEndTimeOffset
        }
        return TimeOffset(second: Int(startDate.distance(to: endDate)))
    }
}
