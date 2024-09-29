//
//  CommonPreview.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/19.
//

import LemonCountdownModel
//import LemonUtils
import SwiftUI
import LemonUtils

@MainActor
struct CommonPreview<Content: View>: View {
    private let container = ModelUtilities.getModelContainer([EventModel.self, EventBackupModel.self, WidgetTemplateModel.self])
    private var vm: ViewModel

    var content: Content

    init(content: Content) {
        self.content = content
        let context = container.mainContext
        vm = ViewModel(modelContext: context)
    }

    var body: some View {
        VStack {
            content
        }
        .environment(vm)
    }
}
