//
//  WidgetTemplateDetailView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import LemonDateUtils
import SwiftUI

// MARK: - Widget Template Detail View

/// A view for managing the details of a widget template.
struct WidgetTemplateDetailView: View {
    let widgetTemplateModel: WidgetTemplateModel
    @State private var widgetTemplate = WidgetTemplate()
    @State private var title = String(localized: "Untitled")
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase
    @Environment(ViewModel.self) private var vm

    @State private var isModifyTemplateTitleAlertShown = false
    @State private var initialized = false
    @State private var isTemplateModelDeleted = false
    @State private var showEventBackupInformationSheet = false

    private var widgetSize: CGSize {
        SizeHelper.getSize(widgetTemplateModel.size)
    }

    private var modifyTitleText: LocalizedStringKey {
        widgetTemplateModel.templateKind == WidgetTemplateKind.baseTemplate.rawValue ? "修改模板标题" : "修改小组件标题"
    }

    private var deleteButtonText: LocalizedStringKey {
        widgetTemplateModel.templateKind == WidgetTemplateKind.baseTemplate.rawValue ? "删除模板" : "删除小组件"
    }

    var body: some View {
        List {
            ForEach(PhaseTimeKind.allCases, id: \.self) { kind in
                PhaseSectionView(
                    kind: kind,
                    widgetTemplate: widgetTemplate,
                    viewModel: vm,
                    widgetSize: widgetSize,
                    eventBackup: widgetTemplateModel.eventBackup,
                    phasesBeforeStartDate: $widgetTemplate.phasesBeforeStartDate,
                    phasesBetweenStartAndStartTime: $widgetTemplate.phasesBetweenStartAndStartTime,
                    phases: $widgetTemplate.phases,
                    phasesBetweenEndTimeAndEndDate: $widgetTemplate.phasesBetweenEndTimeAndEndDate,
                    phasesAfterStartDate: $widgetTemplate.phasesAfterStartDate
                )
            }
        }
        .environment(widgetTemplate)
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .onAppear(perform: onAppear)
        .onDisappear(perform: saveWidgetTemplateModel)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                saveWidgetTemplateModel()
            }
        }
        .sheet(isPresented: $showEventBackupInformationSheet) {
            EventBackupSheetView(eventBackup: widgetTemplateModel.eventBackup)
        }
        .navigationTitle(widgetTemplateModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(modifyTitleText, isPresented: $isModifyTemplateTitleAlertShown) {
            ModifyTitleAlertView(title: $title, onOK: {
                widgetTemplateModel.title = title
            })
        }
    }

    private func onAppear() {
        Logging.openUrl.debug("onAppear WidgetTemplateDetailView: initialized \(initialized) title: \(widgetTemplateModel.title)")
        if !initialized {
            widgetTemplate.updateFromModel(widgetTemplateModel)
            initialized = true
        }
    }

    private func saveWidgetTemplateModel() {
        if isTemplateModelDeleted {
            return
        }

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


struct ModifyTitleAlertView: View {
    @Binding var title: String
    let onOK: () -> Void

    var body: some View {
        Group {
            TextField("Enter template title", text: $title)
            Button("Cancel", role: .cancel) { }
            Button("OK", action: onOK)
        }
    }
}

