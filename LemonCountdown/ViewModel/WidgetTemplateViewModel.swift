//
//  WidgetTemplateViewModel.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/30.
//

import Foundation
import SwiftData
//
// @Observable
// class WidgetTemplateViewModel {
//    var modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//
//    var widgetTemplateModels: [WidgetTemplateModel] = []
//
//    func refresh() {
//        widgetTemplateModels = fetchAllWidgetTemplateModel()
////        Logging.shared.error("fetchAllWidgetTemplateModel refresh, number of widgetTemplateModels: \(widgetTemplateModels.count) ")
//    }
//
//    // 辅助函数，用于查找特定ID的phase
//    private func findPhase(in phases: [WidgetPhase], withID id: UUID) -> WidgetPhase? {
//        return phases.first { $0.id == id }
//    }
//
//    func fetchWidgetPhase(widgetPhaseId: UUID) -> WidgetPhase {
//        for wtm in widgetTemplateModels {
//            let wt = wtm.toWidgetTemplate()
//
//            // 使用辅助函数简化查找逻辑
//            if let phase = findPhase(in: wt.phases, withID: widgetPhaseId) {
//                return phase
//            }
//            if let phase = findPhase(in: wt.phasesBeforeStartDate, withID: widgetPhaseId) {
//                return phase
//            }
//            if let phase = findPhase(in: wt.phasesAfterStartDate, withID: widgetPhaseId) {
//                return phase
//            }
//            if let phase = findPhase(in: wt.phasesBetweenStartAndStartTime, withID: widgetPhaseId) {
//                return phase
//            }
//            if let phase = findPhase(in: wt.phasesBetweenEndTimeAndEndDate, withID: widgetPhaseId) {
//                return phase
//            }
//        }
//        return WidgetPhase(kind: .endTimeAndTaskEndDateDuring, eventInfoProvider: nil)
//    }
//
//    func fetchAllWidgetTemplateModel() -> [WidgetTemplateModel] {
//        let descriptor = FetchDescriptor<WidgetTemplateModel>(sortBy: [SortDescriptor(\WidgetTemplateModel.createTime, order: .reverse)])
//        do {
//            return try modelContext.fetch(descriptor)
//        } catch {
//            Logging.shared.error("fetchAllWidgetTemplateModel error: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    // phase 是否可以被删除
//    func IsphaseCanDelete(phaseId: UUID) -> Bool {
//        return false
//    }
//
//    // 删除 phase
//    func deletePhase(phaseId: UUID) {
//    }
// }
