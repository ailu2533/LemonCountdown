//
//  WidgetTemplatePreview.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/10.
//

import Foundation
import LemonCountdownModel
import SwiftUI

struct WidgetTemplatePreview: View {
    var widgetTempletModel: WidgetTemplateModel

    @State private var phase = WidgetPhase(kind: .taskEndDateAfter, eventInfoProvider: nil)

    var widgetSize: CGSize {
        SizeHelper.getSize(widgetTempletModel.size)
    }

    init(widgetTempletModel: WidgetTemplateModel) {
        self.widgetTempletModel = widgetTempletModel
    }

    var body: some View {
        WidgetCardView(phase: phase, widgetSize: widgetSize)
            .roundedWidget()
            .allowsHitTesting(false)
            .onAppear {
                loadInitialPhase()
            }
    }

    // MARK: - Load Image

    private func loadInitialPhase() {
//        Logging.shared.debug("\(widgetTempletModel.title) loading")
        let widgetTemplate = widgetTempletModel.toWidgetTemplate()

        if let phase = widgetTemplate.phases.first {
            // Create a new WidgetPhase with updated properties
            let updatedPhase = WidgetPhase(
                kind: PhaseTimeKind.taskEndDateAfter,
                eventInfoProvider: widgetTemplate.getWidgetTemplateModel()?.eventBackup,
                stickers: phase.stickers,
                texts: phase.texts,
                eventInfo: phase.eventInfo,
                background: phase.background
            )

//            Logging.widgetPreview.debug("updatedPhase id: \(updatedPhase.id) widgetTemplate: \(widgetTemplate == nil)")
            // Assign the new phase to trigger the view update
            self.phase = updatedPhase
        }
    }
}
