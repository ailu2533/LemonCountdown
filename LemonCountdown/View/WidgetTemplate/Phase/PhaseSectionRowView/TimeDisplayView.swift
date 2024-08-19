//
//  TimeDisplayView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import LemonDateUtils
import SwiftUI

// MARK: - TimeDisplayView

struct TimeDisplayView: View {
    let config: PhaseSectionRowConfiguration
    let phase: WidgetPhase
    @Binding var showSheet: Bool

    var body: some View {
        HStack {
            Text(timeDisplayText)
            Spacer()
            Button(action: {
                showSheet = true
            }, label: {
                Text(timeDisplayButtonLabel)
            }).buttonStyle(BorderedButtonStyle())
                .disabled(config.isLastRowInSection)
        }
    }

    private var timeDisplayText: String {
        if config.useRelativeTimeEditor {
            return config.prevEndTimeOffset.text
        }
        return formattedTime(for: config.prevEndTimeOffset)
    }

    private var timeDisplayButtonLabel: String {
        if config.useRelativeTimeEditor {
            return phase.phaseTimeRule.endTimeOffset_.text
        }
        return formattedTime(for: phase.phaseTimeRule.endTimeOffset_)
    }

    private func formattedTime(for timeOffset: TimeOffset) -> String {
        if timeOffset.isMax {
            return config.endDate!.customFormatted()
        }
        return config.startDate!.addingTimeInterval(timeOffset.toTimeInterval()).customFormatted()
    }
}
