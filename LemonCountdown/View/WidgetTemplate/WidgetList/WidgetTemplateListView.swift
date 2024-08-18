//
//  WidgetTemplateListView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import LemonCountdownModel
import LemonUtils
import SwiftData
import SwiftUI

struct TemplateListView: View {
    @Environment(ViewModel.self)
    private var vm

    // MARK: - Add Template Menu

    @ViewBuilder
    private var addTemplateMenu: some View {
        Menu {
            Button {
                let widgetTempalteModel = WidgetTemplateModel.createWidgetTemplateModel(title: "Test", size: .small)
                vm.modelContext.insert(widgetTempalteModel)
            } label: {
                Text("小号模板")
            }
            Button {
                let widgetTempalteModel = WidgetTemplateModel.createWidgetTemplateModel(title: "Test", size: .medium)
                vm.modelContext.insert(widgetTempalteModel)
            } label: {
                Text("中号模板")
            }
        } label: {
            Label("创建模板", systemImage: "rectangle.stack.badge.plus")
        }
    }

    var body: some View {
        NavigationStack {
            MediumTemplateListView()
                .scrollContentBackground(.hidden)
                .navigationTitle("模板")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        addTemplateMenu
                    }
                })
        }
    }
}

private struct MediumTemplateListView: View {
    @Environment(ViewModel.self)
    private var vm

    static let kind = WidgetTemplateKind.baseTemplate.rawValue

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
