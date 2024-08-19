//
//  WidgetEditorToolbarContent.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftUI

struct WidgetEditorToolbarContent: ToolbarContent {
    private var canDeleted: Bool
    let widgetTemplate: WidgetTemplate
    let phase: WidgetPhase
    let saveAction: () -> Void

    @Environment(\.dismiss)
    private var dismiss

    init(widgetTemplate: WidgetTemplate, phase: WidgetPhase, saveAction: @escaping () -> Void) {
        canDeleted = widgetTemplate.checkCanBeDeleted(phase: phase)
        self.widgetTemplate = widgetTemplate
        self.phase = phase
        self.saveAction = saveAction
    }

    var body: some ToolbarContent {
        if canDeleted {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    Logging.openUrl.debug("widgetTemplate: \(widgetTemplate.id)")
                    widgetTemplate.deleteWidgetPhase(phase)
                    dismiss()
                } label: {
                    Label {
                        Text("删除")
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                saveAction()
                dismiss()
            } label: {
                Label {
                    Text("保存")
                } icon: {
                    Image(systemName: "checkmark.circle")
                }
            }
        }
    }
}
