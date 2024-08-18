//
//  MainView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import LemonCountdownModel
import LemonUtils
import SwiftUI

enum TabKind: Int {
    case event
    case widget
    case settings
}

enum WidgetTemplateDetailTarget: Hashable {
    case widgetTemplateModel(WidgetTemplateModel)
}

struct MainView: View {
    @State private var addEventSheet = false
    @Environment(ViewModel.self) private var vm

    @State private var selection = TabKind.event

    var body: some View {
        @Bindable var vm = vm

        TabView(selection: $selection) {
            NavigationStack(path: $vm.eventNavigationPath) {
                EventListView(navigationTitle: Date().formatted(date: .abbreviated, time: .omitted))
            }.tabItem {
                Label("事件", systemImage: "calendar")
            }.tag(TabKind.event)

            NavigationStack(path: $vm.widgetNavigationPath) {
                WidgetListView()
                    .navigationDestination(for: WidgetTemplateDetailTarget.self, destination: { widgetTemplateDetailTarget in
                        switch widgetTemplateDetailTarget {
                        case let .widgetTemplateModel(widgetTemplateModel):
                            WidgetTemplateDetailView(wt: widgetTemplateModel)
                                .id(widgetTemplateModel.id)
                        }
                    })
            }.tabItem {
                Label("小组件", systemImage: "sun.haze")
            }.tag(TabKind.widget)

            TemplateListView().tabItem {
                Label("模板", systemImage: "rectangle.stack")
            }

            NavigationStack {
                TabSettingsView()
            }.tabItem {
                Label("设置", systemImage: "gear")
            }.tag(TabKind.settings)
        }.onAppear {
            // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            tabBarAppearance.backgroundColor = UIColor(Color(.systemBackground))
        }
        .onOpenURL { url in
            handleURL(url)
        }
    }

    private func handleURL(_ url: URL) {
        // 解析 URL 并导航到相应的视图
        if url.scheme == "myapp" {
            if url.host == "tutorial" {
                selection = .widget
                vm.widgetNavigationPath = NavigationPath()

                let widget = WidgetTemplateModel.createWidgetTemplateModel(title: "测试", size: .medium)
                vm.widgetNavigationPath.append(WidgetTemplateDetailTarget.widgetTemplateModel(widget))
            } else {
                guard let widgetTemplateId = url.host else {
                    return
                }

                guard let widgetTemplateModel = vm.queryWidgetTemplateModel(by: widgetTemplateId) else {
                    return
                }

                selection = .widget
                vm.widgetNavigationPath = NavigationPath()

                vm.widgetNavigationPath.append(WidgetTemplateDetailTarget.widgetTemplateModel(widgetTemplateModel))
            }
        }
    }
}

#Preview {
    CommonPreview(content: MainView())
}

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}
