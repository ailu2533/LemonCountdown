//
//  PhaseSectionView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import LemonDateUtils
import SwiftUI

struct PhaseSectionView: View {
    let kind: PhaseTimeKind
    let widgetTemplate: WidgetTemplate
    let viewModel: ViewModel
    let widgetSize: CGSize
    let eventBackup: EventBackupModel?

    @Binding var phasesBeforeStartDate: [WidgetPhase]
    @Binding var phasesBetweenStartAndStartTime: [WidgetPhase]
    @Binding var phases: [WidgetPhase]
    @Binding var phasesBetweenEndTimeAndEndDate: [WidgetPhase]
    @Binding var phasesAfterStartDate: [WidgetPhase]

    var body: some View {
        switch kind {
        case .taskStartDateBefore:
            PhaseSection(sectionConfig: phaseSectionConfig(),
                         viewModel: viewModel,
                         phases: $phasesBeforeStartDate)
        case .taskStartDateAndStartTimeDuring:
            if shouldShowStartTimeDuringSection {
                PhaseSection(sectionConfig: phaseSectionConfig(),
                             viewModel: viewModel,
                             phases: $phasesBetweenStartAndStartTime)
            }
        case .taskStartTimeAndEndTimeDuring:
            PhaseSection(sectionConfig: phaseSectionConfig(),
                         viewModel: viewModel,
                         phases: $phases)
        case .endTimeAndTaskEndDateDuring:
            if shouldShowEndTimeDuringSection {
                PhaseSection(sectionConfig: phaseSectionConfig(),
                             viewModel: viewModel,
                             phases: $phasesBetweenEndTimeAndEndDate)
            }
        case .taskEndDateAfter:
            if shouldShowEndDateAfterSection {
                PhaseSection(sectionConfig: phaseSectionConfig(),
                             viewModel: viewModel,
                             phases: $phasesAfterStartDate)
            }
        }
    }

    private func phaseSectionConfig() -> PhaseSectionConfiguration {
        PhaseSectionConfiguration.Builder()
            .setTitle(getSectionTitle())
            .setAddLabel(addLabelFor())
            .setWidgetSize(widgetSize)
            .setTiming(kind)
            .setShowAddButton(kind == .taskStartTimeAndEndTimeDuring)
            .setShowTime(kind == .taskStartTimeAndEndTimeDuring)
            .setUseRelativeTime(eventBackup == nil)
            .setStartDate(eventBackup?.startDate)
            .setEndDate(eventBackup?.endDate)
            .build()
    }

    private func addLabelFor() -> String {
        switch kind {
        case .taskStartDateBefore: return "Add Before"
        case .taskStartDateAndStartTimeDuring, .endTimeAndTaskEndDateDuring, .taskEndDateAfter: return "Add between"
        case .taskStartTimeAndEndTimeDuring: return "Add Task"
        }
    }

    private var shouldShowStartTimeDuringSection: Bool {
        guard let eventBackup = eventBackup else { return true }
        return !eventBackup.isAllDayEvent && eventBackup.nextStartDate != eventBackup.nextEndDate.adjust(for: .startOfDay)!
    }

    private var shouldShowEndTimeDuringSection: Bool {
        eventBackup?.isAllDayEvent != true
    }

    private var shouldShowEndDateAfterSection: Bool {
        guard let eventBackup = eventBackup else { return true }
        return !(eventBackup.isRepeatEnabled && eventBackup.repeatEndDate == nil)
    }

    private func getSectionTitle() -> String {
        guard let eventBackup = eventBackup else {
            return kind.text
        }

        let formattedStartDate = formatDate(eventBackup.nextStartDate)
        let formattedEndDate = formatDate(eventBackup.nextEndDate)

        switch kind {
        case .taskStartDateBefore:
            return String("\(formattedStartDate)")

        case .taskStartDateAndStartTimeDuring:
            let startTime = formatTime(eventBackup.nextStartDate, adjustFor: .startOfDay)
            let endTime = formatTime(eventBackup.nextStartDate)
            return String("\(startTime) - \(endTime)")

        case .taskStartTimeAndEndTimeDuring:
            let startTime = formatTime(eventBackup.nextStartDate)
            let endTime = formatTime(eventBackup.nextEndDate, adjustFor: eventBackup.isAllDayEvent ? .endOfDay : nil)
            return String("\(formattedEndDate) \(startTime) - \(endTime)")

        case .endTimeAndTaskEndDateDuring:
            let startTime = formatTime(eventBackup.nextEndDate)
            let endTime = formatTime(eventBackup.nextEndDate, adjustFor: .endOfDay)
            return String("\(startTime) - \(endTime)")

        case .taskEndDateAfter:
            return handleRepeatingEvents(eventBackup)
        }
    }

    private func formatDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    private func formatTime(_ date: Date, adjustFor adjustment: DateAdjustment? = nil) -> String {
        if let adjustment {
            return date.adjust(for: adjustment).formatted(date: .omitted, time: .standard)
        }
        return date.formatted(date: .omitted, time: .standard)
    }

    private func handleRepeatingEvents(_ eventBackup: EventBackupModel) -> String {
        if eventBackup.isRepeatEnabled, let repeatEndDate = eventBackup.repeatEndDate {
            switch eventBackup.recurrenceType {
            case .singleCycle:
                let lastRepeatDate = calculateLastRepeatDateBeforeEndDate(
                    startDate: eventBackup.startDate,
                    endDate: repeatEndDate,
                    repeatPeriod: eventBackup.repeatPeriod,
                    interval: eventBackup.repeatInterval
                )
                return String("\(formatDate(lastRepeatDate))")
            case .customWeekly:
                let lastRepeatDate = calculateLastCustomWeeklyRepeatDateBeforeEndDate(
                    startDate: eventBackup.startDate,
                    endDate: repeatEndDate,
                    customWeek: eventBackup.repeatCustomWeekly
                )
                return String("\(formatDate(lastRepeatDate))")
            }
        }
        return String("\(formatDate(eventBackup.nextEndDate))")
    }
}
