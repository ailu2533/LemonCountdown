//
//  TabSettingsView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/2.
//

import RevenueCat
import RevenueCatUI
// import Setting
import SwiftUI

struct PremiumRight: View {
    let benefits = [
        ("编辑小组件", "🔒", "✅"),
        ("创建循环事件", "🔒", "✅"),
        ("高级主题", "🔒", "✅"),
        ("无广告体验", "🔒", "✅")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("会员权益介绍")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    Text("权益名称")
                        .font(.title2)
//                        .bold()
                        .padding(.bottom, 10)
                    Text("普通用户")
                        .font(.title2)
//                        .bold()
                        .padding(.bottom, 10)
                    Text("会员用户")
                        .font(.title2)
//                        .bold()
                        .padding(.bottom, 10)
                }

                ForEach(benefits, id: \.0) { benefit in
                    GridRow {
                        Text(benefit.0)
                        Text(benefit.1)
                            .gridColumnAlignment(.center)

                        Text(benefit.2)
                            .gridColumnAlignment(.center)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

struct TabSettingsView: View {
    @Environment(\.openURL) private var openURL

    @Environment(ViewModel.self) private var vm

    @State private var showPaywallSheet = false
    @State private var showPremiumSheet = false

    var body: some View {
        Form {
//            PremiumCard()
//                .listRowSpacing(0)
//                .listRowInsets(.none)
//                .listRowBackground(Color(.clear))
//                .listSectionSpacing(0)

            Section {
                HStack {
                    Image(systemName: "tag")
                    NavigationLink("标签管理") {
                        TagManagementView()
                    }
                }
            }

            NavigationLink {
               TutorialView()
            } label: {
                HStack {
                    Image(systemName: "lightbulb.max")
                    Text("小组件定制指南")
                }
            }

//            Section {
//                Button {
//                    do {
//                        try vm.modelContext.delete(model: WidgetTemplateModel.self)
//                    } catch {
//                        Logging.shared.debug("error \(error)")
//                    }
//
//                } label: {
//                    Text("删除所有模板")
//                }
//            }

            Section("联系我们") {
                HStack {
                    Image(systemName: "person.2")
                    Button("小红书") {
                        if let url = URL(string: "xhsdiscover://user/60ba522d0000000001008b88") {
                            openURL(url)
                        }
                    }
                }

                HStack {
                    Image(systemName: "hand.thumbsup")
                    Button("给我们好评") {
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6499009310?action=write-review") {
                            openURL(url)
                        }
                    }
                }

                HStack {
                    Image(systemName: "envelope")
                    Button("问题反馈") {
                        if let url = URL(string: "https://docs.qq.com/sheet/DWllUVmZwS21sd1Zw?tab=BB08J2") {
                            openURL(url)
                        }
                    }
                }
            }
        }

        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)

//        .scrollContentBackground(.hidden)
        .toolbar(.visible, for: .navigationBar)
        .sheet(isPresented: $showPaywallSheet, onDismiss: {
            MembershipManager.shared.checkMembershipStatus()
        }, content: {
            PaywallView(displayCloseButton: true)
//                .onRestoreCompleted { info in
//                    MembershipManager.shared.checkMembershipStatus()
//                    Logging.shared.debug("onRestoreCompleted \(info.entitlements.debugDescription)")
//                }
//
//                .onRestoreFailure { error in
//                    Logging.shared.error("onRestoreFailure: \(error.localizedDescription)")
//                }
//                .onPurchaseCompleted { _ in
//                    MembershipManager.shared.checkMembershipStatus()
//                }
//                .onDismiss {
//                    MembershipManager.shared.checkMembershipStatus()
            ////                                print("Paywall was dismissed either manually or automatically after a purchase.")
//                }

        })

        .sheet(isPresented: $showPremiumSheet, content: {
            PremiumRight()
        })
    }
}
