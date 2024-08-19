//
//  MainView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import LemonCountdownModel
import LemonUtils
import SwiftUI

enum WidgetTemplateDetailTarget: Hashable {
    case widgetTemplateModel(WidgetTemplateModel)
}

struct MainView: View {
    @State private var selection: TabItem = .event
    @Environment(ViewModel.self) private var vm

    var body: some View {
        TabView(selection: $selection) {
            ForEach(TabItem.allCases) { item in
                item.tabView(vm: vm)
                    .tabItem {
                        Label(item.title, systemImage: item.icon)
                    }
                    .tag(item)
            }
        }
        .onAppear {
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
                guard let widgetTemplateId = url.host,
                      let widgetTemplateModel = vm.queryWidgetTemplateModel(by: widgetTemplateId) else {
                    return
                }

                selection = .widget
                vm.widgetNavigationPath = NavigationPath()
                vm.widgetNavigationPath.append(WidgetTemplateDetailTarget.widgetTemplateModel(widgetTemplateModel))
            }
        }
    }
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
