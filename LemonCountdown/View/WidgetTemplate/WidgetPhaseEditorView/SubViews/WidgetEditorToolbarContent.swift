//
//  WidgetEditorToolbarContent.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonCountdownModel

struct WidgetEditorToolbarContent: ToolbarContent {
    let canDeleted: Bool
    let widgetTemplate: WidgetTemplate
    let phase: WidgetPhase
    let dismiss: DismissAction
    let saveAction: () -> Void

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
