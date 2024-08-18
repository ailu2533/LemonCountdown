//
//  WidgetTemplateList.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import LemonCountdownModel
import LemonUtils
import RevenueCatUI
import SwiftData
import SwiftUI
import TipKit

struct CreateWidgetNavigationValue: Hashable {
}

struct WidgetListView: View {
    @Environment(ViewModel.self)
    private var vm

    @State private var showPaywallSheet = false

    let tip = CreateWidgetTip()

    // MARK: - Add Template Menu

    @ViewBuilder
    private var addTemplateMenu: some View {
        Button {
//            if MembershipManager.shared.isPremiumUser == false && vm.queryWidgetInstanceCount() >= 3 {
//                showPaywallSheet = true
//                return
//            }

            vm.showSelectedEventSheet = true
        } label: {
            Label("创建小组件", systemImage: "rectangle.badge.plus")
        }
    }

    var body: some View {
        @Bindable var vm = vm

        VStack {
            TipView(tip).padding()
            MediumWidgetListView()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("小组件")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                addTemplateMenu
            }
        })
        .sheet(isPresented: $vm.showSelectedEventSheet, onDismiss: {
            if let callback = vm.sheetDismissCallback {
                callback()
                vm.sheetDismissCallback = nil
            }
        }) {
            WidgetCreationView()
                .interactiveDismissDisabled()
        }

        .sheet(isPresented: $showPaywallSheet, onDismiss: {
            MembershipManager.shared.checkMembershipStatus()
        }, content: {
            PaywallView()
        })
    }
}

private struct MediumWidgetListView: View {
    @Environment(ViewModel.self)
    private var vm

    static let kind = WidgetTemplateKind.widgetInstance.rawValue

    @Query(
        filter: #Predicate<WidgetTemplateModel> { model in
            model.templateKind == kind
        }
        , sort: [SortDescriptor(\WidgetTemplateModel.sizeStore, order: .reverse),
                 SortDescriptor(\WidgetTemplateModel.createTime, order: .reverse)])
    private var allWidgets: [WidgetTemplateModel] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach(allWidgets) { widget in
                        if widget.size == .medium {
                            mediumWidgetView(widget)
                        }
                    }
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(allWidgets) { widget in
                        if widget.size == .small {
                            mediumWidgetView(widget)
                        }
                    }
                }
            }.padding()
        }
    }

    @ViewBuilder
    private func mediumWidgetView(_ widget: WidgetTemplateModel) -> some View {
        VStack {
            NavigationLink {
                WidgetTemplateDetailView(wt: widget)
            } label: {
                WidgetTemplatePreview(widgetTempletModel: widget)
                    .overlay(content: {
                        Color.white.opacity(0.01)
                    })
            }
            Text(widget.title)
        }
    }
}
