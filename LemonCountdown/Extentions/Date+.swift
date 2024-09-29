//
//  Date+.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
//import LemonUtils
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

// @ToolbarContentBuilder
// private var toolbarContent: some ToolbarContent {
//    ToolbarItemGroup(placement: .navigationBarTrailing) {
//        Menu {
//            if widgetTemplateModel.templateKind == WidgetTemplateKind.widgetInstance.rawValue &&
//                widgetTemplateModel.eventBackup != nil {
//                Button {
//                    showEventBackupInformationSheet = true
//                    Logging.widgetEntries.debug("enventBackup: \(widgetTemplateModel.eventBackup?.description ?? "None")")
//                } label: {
//                    Text("查看事件信息")
//                }
//            }
//
//            Button(action: {
//                title = widgetTemplateModel.title
//                isModifyTemplateTitleAlertShown.toggle()
//            }, label: {
//                Text(modifyTitleText)
//            })
//
//            Button(role: .destructive, action: {
//                modelContext.delete(widgetTemplateModel)
//                try? modelContext.save()
//                isTemplateModelDeleted = true
//                dismiss()
//            }, label: {
//                Text(deleteButtonText)
//            })
//        } label: {
//            Image(systemName: "ellipsis")
//        }
//    }
// }
