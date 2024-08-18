//
//  ViewModel+Widget.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/7.
//

import Foundation
import LemonCountdownModel
import SwiftData

extension ViewModel {
    var allWidgets: [WidgetTemplateModel] {
        _ = widgetListVersion
        return fetchAllWidgetTemplateModels()
    }

    func fetchAllWidgetTemplateModels() -> [WidgetTemplateModel] {
        Logging.shared.info("fetchAllWidgetTemplateModels")

        let descriptor = FetchDescriptor<WidgetTemplateModel>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print(error)
            return []
        }
    }

    func getFilteredWidgets(by size: WidgetSize) -> [WidgetTemplateModel] {
        let all = fetchAllWidgetTemplateModels()
        return all.filter { $0.size == size }
    }

    func queryWidgetTemplateModel(by widgetTemplateId: String) -> WidgetTemplateModel? {
        Logging.openUrl.info("queryWidgetTemplateModel widgetTemplateId:\(widgetTemplateId)")

        let uuid = UUID(uuidString: widgetTemplateId)!

        let instanceKind = WidgetTemplateKind.widgetInstance.rawValue
        let descriptor = FetchDescriptor<WidgetTemplateModel>(predicate: #Predicate {
            $0.uuid == uuid && $0.templateKind == instanceKind
        })
        do {
            let res = try modelContext.fetch(descriptor)

//            assert(res.count == 1, "assert fail")

            return res.first
        } catch {
            Logging.shared.error("queryWidgetTemplateModel error: \(error.localizedDescription)")
            return nil
        }
    }

    // 获取 widgetTemplate 的数量
    func queryWidgetInstanceCount() -> Int {
        Logging.openUrl.info("queryWidgetTemplateModelInstanceCount ")

        let instanceKind = WidgetTemplateKind.widgetInstance.rawValue
        let descriptor = FetchDescriptor<WidgetTemplateModel>(predicate: #Predicate {
            $0.templateKind == instanceKind
        })
        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            Logging.shared.error("queryWidgetTemplateModel error: \(error.localizedDescription)")
            return 0
        }
    }
}
