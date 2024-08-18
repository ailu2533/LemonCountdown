//
//  WidgetTemplateLIst.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/21.
//

import Foundation
import LemonCountdownModel
import SwiftData
import SwiftUI

struct WidgetTemplateSelectionView: View {
    @Environment(ViewModel.self) private var vm

    var previewTapCallback: (WidgetTemplateModel) -> Void = { _ in }
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
            Button {
                previewTapCallback(widget)
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
