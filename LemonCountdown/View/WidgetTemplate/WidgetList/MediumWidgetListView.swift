//
//  MediumWidgetListView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

struct MediumWidgetListView: View {
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
