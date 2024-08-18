//
//  WidgetTemplateDetail.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import LemonCountdownModel
import LemonDateUtils
import LemonUtils
import SwiftUI
import TipKit

enum DateAdjustment {
    case startOfDay
    case endOfDay
}

extension Date {
    func adjust(for adjustment: DateAdjustment) -> Date {
        let calendar = Calendar.current
        switch adjustment {
        case .startOfDay:
            return calendar.startOfDay(for: self)
        case .endOfDay:
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return calendar.date(byAdding: components, to: calendar.startOfDay(for: self))!
        }
    }
}

// enum NavigationTarget: Hashable {
//    case phase(WidgetPhase)
// }

// MARK: - Widget Template Detail View

/// A view for managing the details of a widget template.
struct WidgetTemplateDetailView: View {
    let widgetTemplateModel: WidgetTemplateModel

    @State private var widgetTemplate = WidgetTemplate()
    @State private var title = String(localized: "Untitled")
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase

    @Environment(ViewModel.self)
    private var vm

    @State private var day = 0
    @State private var isModifyTemplateTitleAlertShown = false
    @State private var showDatePickerSheet = false
    @State private var initialized = false
    @State private var isTemplateModelDeleted = false
    @State private var showEventBackupInformationSheet = false

    private let tip = WidgetDetailTip()

    var widgetSize: CGSize {
        SizeHelper.getSize(widgetTemplateModel.size)
    }

    var modifyTitleText: LocalizedStringKey {
        if widgetTemplateModel.templateKind == WidgetTemplateKind.baseTemplate.rawValue {
            return "修改模板标题"
        }
        return "修改小组件标题"
    }

    var deleteButtonText: LocalizedStringKey {
        if widgetTemplateModel.templateKind == WidgetTemplateKind.baseTemplate.rawValue {
            return "删除模板"
        }
        return "删除小组件"
    }

    init(wt widgetTemplateModel: WidgetTemplateModel) {
        Logging.openUrl.debug("init WidgetTemplateDetailView: WidgetTemplateModel\(widgetTemplateModel.title)")
        self.widgetTemplateModel = widgetTemplateModel
    }

    func getSectionTitle(_ kind: PhaseTimeKind) -> String {
        guard let eventBackup = widgetTemplateModel.eventBackup else {
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

    var body: some View {
        List {
//            TipView(tip)
            PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                .setTitle(getSectionTitle(.taskStartDateBefore))
                .setAddLabel("Add Before")
                .setWidgetSize(widgetSize)
                .setTiming(.taskStartDateBefore)
                .build(), viewModel: vm,
                phases: $widgetTemplate.phasesBeforeStartDate)

            if let eventBackup = widgetTemplateModel.eventBackup, eventBackup.isAllDayEvent || eventBackup.nextStartDate == eventBackup.nextEndDate.adjust(for: .startOfDay)! {
                EmptyView()
            } else {
                PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                    .setTitle(getSectionTitle(.taskStartDateAndStartTimeDuring))
                    .setAddLabel("Add between")
                    .setWidgetSize(widgetSize)
                    .setTiming(.taskStartDateAndStartTimeDuring)
                    .build()
                    , viewModel: vm,
                    phases: $widgetTemplate.phasesBetweenStartAndStartTime)
            }

            if let eventBackup = widgetTemplateModel.eventBackup {
                PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                    .setTitle(getSectionTitle(.taskStartTimeAndEndTimeDuring))
                    .setAddLabel("Add Task")
                    .setWidgetSize(widgetSize)
                    .setTiming(.taskStartTimeAndEndTimeDuring)
                    .setShowAddButton(true)
                    .setShowTime(true)
                    .setUseRelativeTime(false)
                    .setStartDate(eventBackup.startDate)
                    .setEndDate(eventBackup.endDate)
                    .build(), viewModel: vm,
                    phases: $widgetTemplate.phases)
            } else {
                PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                    .setTitle(getSectionTitle(.taskStartTimeAndEndTimeDuring))
                    .setAddLabel("Add Task")
                    .setWidgetSize(widgetSize)
                    .setTiming(.taskStartTimeAndEndTimeDuring)
                    .setShowAddButton(true)
                    .setShowTime(true)
                    .setUseRelativeTime(true)
                    .setStartDate(nil)
                    .setEndDate(nil)
                    .build(), viewModel: vm,
                    phases: $widgetTemplate.phases)
            }

            if let eventBackup = widgetTemplateModel.eventBackup, eventBackup.isAllDayEvent {
                EmptyView()
            } else {
                PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                    .setTitle(getSectionTitle(.endTimeAndTaskEndDateDuring))
                    .setAddLabel("Add between")
                    .setWidgetSize(widgetSize)
                    .setTiming(.endTimeAndTaskEndDateDuring)
                    .build(), viewModel: vm,
                    phases: $widgetTemplate.phasesBetweenEndTimeAndEndDate)
            }

            if let eventBackup = widgetTemplateModel.eventBackup, eventBackup.isRepeatEnabled && eventBackup.repeatEndDate == nil {
                EmptyView()
            } else {
                PhaseSection(sectionConfig: PhaseSectionConfiguration.Builder()
                    .setTitle(getSectionTitle(.taskEndDateAfter))
                    .setAddLabel("Add between")
                    .setWidgetSize(widgetSize)
                    .setTiming(.taskEndDateAfter)
                    .build(), viewModel: vm,
                    phases: $widgetTemplate.phasesAfterStartDate)
            }
        }
        .environment(widgetTemplate)

        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .onAppear {
            Logging.openUrl.debug("onAppear WidgetTemplateDetailView: initialized \(initialized) title: \(widgetTemplateModel.title)")

            if !initialized {
                widgetTemplate.updateFromModel(widgetTemplateModel)

                initialized = true
            }
        }
        .onDisappear {
            Logging.openUrl.debug("onDisappear WidgetTemplateDetailView: uuid: \(widgetTemplateModel.uuid) title: \(widgetTemplateModel.title)")

            saveWidgetTemplateModel()
        }
        .onChange(of: scenePhase, { _, newValue in
            if newValue == .inactive {
                Logging.openUrl.debug("onChange scenePhase WidgetTemplateDetailView: uuid: \(widgetTemplateModel.uuid) title: \(widgetTemplateModel.title)")

                saveWidgetTemplateModel()
            }
        })
        .sheet(isPresented: $showEventBackupInformationSheet, content: {
            Group {
                if let eventBackup = widgetTemplateModel.eventBackup {
                    EventBackupView(eventBackup: eventBackup)
                } else {
                    EmptyView()
                }
            }.presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        })

        .navigationTitle(widgetTemplateModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            toolbarContent
        })
        .alert(modifyTitleText, isPresented: $isModifyTemplateTitleAlertShown) {
            TextField("Enter template title", text: $title)
            Button("Cancel", role: .cancel) { }
            Button(action: {
                widgetTemplateModel.title = title
            }, label: {
                Text("OK")
            })
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                if widgetTemplateModel.templateKind == WidgetTemplateKind.widgetInstance.rawValue &&
                    widgetTemplateModel.eventBackup != nil {
                    Button {
                        showEventBackupInformationSheet = true
                        Logging.widgetEntries.debug("enventBackup: \(widgetTemplateModel.eventBackup?.description ?? "None")")
                    } label: {
                        Text("查看事件信息")
                    }
                }

                Button(action: {
                    title = widgetTemplateModel.title
                    isModifyTemplateTitleAlertShown.toggle()
                }, label: {
                    Text(modifyTitleText)
                })

                Button(role: .destructive, action: {
                    modelContext.delete(widgetTemplateModel)
                    try? modelContext.save()
                    isTemplateModelDeleted = true
                    dismiss()
                }, label: {
                    Text(deleteButtonText)
                })
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }

    func saveWidgetTemplateModel() {
        if isTemplateModelDeleted {
            return
        }

//        Logging.shared.debug("\(widgetTemplateModel.title) \(widgetTemplate.phases.debugDescription)")

        guard widgetTemplateModel.uuid == widgetTemplate.getWidgetTemplateModel()?.uuid else {
            Logging.openUrl.error("id不匹配 widgetTemplateModel.uuid: \(widgetTemplateModel.uuid) wt.model.uuid: \(widgetTemplate.getWidgetTemplateModel()?.uuid.uuidString ?? "nil")")
            return
        }

        widgetTemplateModel.jsonData = WidgetTemplateModel.encodeWidgetTemplate(widgetTemplate)

        Logging.openUrl.debug("detailView saveWidgetTemplateModel: \(widgetTemplateModel.title) \(widgetTemplateModel.uuid) template: \(widgetTemplate.hashValue)")

        if widgetTemplateModel.modelContext == nil {
            modelContext.insert(widgetTemplateModel)
        }
    }
}

struct EventBackupView: View {
    let eventBackup: EventBackupModel
    var body: some View {
        Form {
            Section {
                LabeledContent("标题") {
                    Text(eventBackup.title)
                }

                LabeledContent("目标日期") {
                    Text(eventBackup.startDate.formatted(date: .abbreviated, time: .omitted))
                }

                if !eventBackup.isAllDayEvent {
                    LabeledContent("开始时间") {
                        Text(eventBackup.startDate.customFormatted())
                    }

                    LabeledContent("结束时间") {
                        Text(eventBackup.endDate.customFormatted())
                    }
                }
            }

            // 重复规则
            if eventBackup.isRepeatEnabled {
                // TODO:

                switch eventBackup.recurrenceType {
                case .singleCycle:
                    Text(repeatText(recurrenceType: eventBackup.recurrenceType, repeatPeriod: eventBackup.repeatPeriod, repeatInterval: eventBackup.repeatInterval))
                case .customWeekly:

                    Text("自定义每周重复")

                    Text(repeatTextCustomWeekly(repeatCustomWeekly: eventBackup.repeatCustomWeekly))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let repeatEndDate = eventBackup.repeatEndDate {
                    LabeledContent("重复结束时间") {
                        Text(repeatEndDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            } else {
                Text("不重复")
            }

            Section {
                Text("创建小组件时，系统会复制绑定的事件。即使后续修改或删除原事件，也不会影响已创建的小组件。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.listRowBackground(Color(.clear))
                .listSectionSpacing(6)
        }
    }
}

extension Date {
    func customFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current // Use the current system locale
        formatter.timeZone = TimeZone.current
        // formatter.dateFormat = "MM/dd/yyyy, HH:mm" // HH for 24-hour format with leading zero
        return formatter.string(from: self)
    }
}
