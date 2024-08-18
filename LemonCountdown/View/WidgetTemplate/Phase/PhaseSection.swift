//
//  PhaseSection.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/11.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
import LemonUtils
import SwiftUI

public struct PhaseSection: View {
    public var sectionConfig: PhaseSectionConfiguration
    var viewModel: ViewModel
//    var kind: WidgetPhaseTimeKind
    @Binding var phases: [WidgetPhase]

    @State private var isExpanded = true
    @State private var tapAdd = 0

    public var body: some View {
        Section(isExpanded: $isExpanded) {
            phaseList

            if sectionConfig.showAddButton {
                addButton
            }
        } header: {
            VStack(alignment: .leading) {
                Text(sectionConfig.timing.text)
                if sectionConfig.timing.text != sectionConfig.title {
                    Text(sectionConfig.title)
                        .font(.caption)
                }
            }
        }
    }

    private var phaseList: some View {
        ForEach(phases.indices, id: \.self) { index in
            PhaseRow(index: index,
                     phase: phases[index],
                     sectionConfig: sectionConfig,
                     viewModel: viewModel,
                     phases: phases)
        }
    }

    @ViewBuilder
    private var addButton: some View {
        HStack {
            Spacer()
            addPhaseButton
            Spacer()
        }
    }

    private var addPhaseButton: some View {
        WidgetCardView(phase: WidgetPhase(kind: sectionConfig.timing, eventInfoProvider: nil, background: Background(kind: .macaronColors, backgroundColor: ColorSets.macaronColors.first)), widgetSize: sectionConfig.widgetSize)
            .overlay(plusIcon)
            .overlay(addPhaseTapArea)
    }

    private var plusIcon: some View {
        Image(systemName: "plus")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(.accent)
    }

    private var addPhaseTapArea: some View {
        Color.white.opacity(0.01)
            .onTapGesture {
                addNewLastPhase()
            }
    }

    private func addNewLastPhase() {
        guard let lastPhase = phases.last else { return }
        // 配置和section 里面的第一个 phase 一样

        let newLastPhase = WidgetPhase(kind: lastPhase.kind, eventInfoProvider: lastPhase.getEventInfoProvider(), background: lastPhase.background.deepCopy())
        newLastPhase.phaseTimeRule.endTimeOffset_ = TimeOffset(isMax: true)

        Logging.eventInfo.debug("newLastPhase: \(newLastPhase)")

        tapAdd += 1
        phases.append(newLastPhase)
    }
}

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
