//
//  TabItem.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import SwiftUI

enum TabItem: Int, CaseIterable, Identifiable {
    case event
    case widget
    case template
    case settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .event: return "事件"
        case .widget: return "小组件"
        case .template: return "模板"
        case .settings: return "设置"
        }
    }

    var icon: String {
        switch self {
        case .event: return "calendar"
        case .widget: return "sun.haze"
        case .template: return "rectangle.stack"
        case .settings: return "gear"
        }
    }

    @ViewBuilder
    func tabView(vm: ViewModel) -> some View {
        @Bindable var vm = vm

        switch self {
        case .event:
            NavigationStack(path: $vm.eventNavigationPath) {
                EventListView(showAddButton: true, navigationTitle: Date().formatted(date: .abbreviated, time: .omitted))
            }
        case .widget:
            NavigationStack(path: $vm.widgetNavigationPath) {
                WidgetListView()
                    .navigationDestination(for: WidgetTemplateDetailTarget.self) { widgetTemplateDetailTarget in
                        switch widgetTemplateDetailTarget {
                        case let .widgetTemplateModel(widgetTemplateModel):
                            WidgetTemplateDetailView(wt: widgetTemplateModel)
                                .id(widgetTemplateModel.id)
                        }
                    }
            }
        case .template:
            TemplateListView()
        case .settings:
            NavigationStack {
                TabSettingsView()
            }
        }
    }
}
