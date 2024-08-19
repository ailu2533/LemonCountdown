//
//  PhaseRow.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import LemonDateUtils
import SwiftUI

struct PhaseRow: View {
    let index: Int
    let phase: WidgetPhase
    var sectionConfig: PhaseSectionConfiguration
    var viewModel: ViewModel
    var phases: [WidgetPhase]

    var body: some View {
        VStack {
            let prevEndTimeOffset: TimeOffset = (index > 0 ? phases[index - 1].phaseTimeRule.endTimeOffset_ : TimeOffset())
            let nextEndTimeOffset: TimeOffset = (index == phases.count - 1) ? TimeOffset(isMax: true) : phases[index + 1].phaseTimeRule.endTimeOffset_
            let isLastRowInSection = (index == phases.count - 1)

            PhaseSectionRowView(config: PhaseSectionRowConfiguration.Builder()
                .setWidgetSize(sectionConfig.widgetSize)
                .setEnableModify(false)
                .setShowTime(sectionConfig.showTime)
                .setIsLastRowInSection(isLastRowInSection)
                .setUseRelativeTimeEditor(sectionConfig.useRelatvieTime)
                .setStartDate(sectionConfig.startDate)
                .setEndDate(sectionConfig.endDate)
                .setPrevEndTimeOffset(prevEndTimeOffset)
                .setNextEndTimeOffset(nextEndTimeOffset)

                .build(),
                phase: phase)
        }.listRowSeparator(.hidden)
    }
}
