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

