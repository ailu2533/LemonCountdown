//
//  ModelHelper.swift
//  LemonEventWidgetsExtension
//
//  Created by ailu on 2024/5/8.
//

import Foundation
import LemonCountdownModel
import SwiftData
import UIKit

// enum WidgetSize: Int, CaseIterable, Identifiable, Codable {
//    case small = 0
//    case medium = 1
//    case large = 2
//
//    var text: String {
//        switch self {
//        case .small:
//            return String(localized: "Small Widget")
//        case .medium:
//            return String(localized: "Medium Widget")
//        case .large:
//            return String(localized: "Large Widget")
//        }
//    }
//
//    var id: Int {
//        return rawValue
//    }
// }

struct ScreenSize: Hashable, Equatable {
    var width: CGFloat
    var height: CGFloat

    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }

    static func == (lhs: ScreenSize, rhs: ScreenSize) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

public struct SizeHelper {
    private static let smallMap = buildSmallWidgetSize()
    private static let mediumMap = buildMediumWidgetSize()
    private static let largeMap = buildLargeWidgetSize()

    static func getSmall() -> CGSize {
        let s = UIScreen.main.bounds
        return smallMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 148, height: 148)
    }

    static func getMedium() -> CGSize {
        let s = UIScreen.main.bounds
        return mediumMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 321, height: 148)
    }

    static func getLarge() -> CGSize {
        let s = UIScreen.main.bounds
        return largeMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 321, height: 337)
    }

    static func getSize(_ ws: WidgetSize) -> CGSize {
        switch ws {
        case .small:
            getSmall()
        case .medium:
            getMedium()
//        case .large:
//            getLarge()
        }
    }

    // 根据 iphone 的 resolution 决定 widget 的 size
    static func buildSmallWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 170, height: 170)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 158, height: 158)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 170, height: 170)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 158, height: 158)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 155, height: 155)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 148, height: 148)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 155, height: 155)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 169, height: 169)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 169, height: 169)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 159, height: 159)

        return mp
    }

    static func buildMediumWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 364, height: 170)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 338, height: 158)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 364, height: 170)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 338, height: 158)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 155)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 321, height: 148)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 155)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 169)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 169)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 348, height: 159)

        return mp
    }

    static func buildLargeWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 364, height: 380)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 338, height: 354)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 364, height: 380)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 338, height: 354)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 345)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 321, height: 337)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 345)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 376)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 376)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 348, height: 364)

        return mp
    }
}

class WidgetModelHelper {
    @MainActor
    public static func fetchSmallWidget() -> [WidgetEntityQuerySmall] {
        let modelContainer = WidgetModelHelper.container

        let widgetFetchDescriptor = FetchDescriptor<WidgetTemplateModel>()

        do {
            let widgets = try modelContainer.mainContext.fetch(widgetFetchDescriptor)
            let result = widgets.filter { $0.templateKind == WidgetTemplateKind.widgetInstance.rawValue && $0.size == .small }.map { widgettemplatemodel in
                widgettemplatemodel.toSmall()
            }

            Logging.shared.debug("result: \(result)")
            return result
        } catch {
            Logging.shared.error("Failed to fetch widgets: \(error)")
        }

        return []
    }

    @MainActor
    public static func fetchMediumWidget() -> [WidgetEntityQueryMedium] {
        let modelContainer = WidgetModelHelper.container

        let widgetFetchDescriptor = FetchDescriptor<WidgetTemplateModel>()

        do {
            let widgets = try modelContainer.mainContext.fetch(widgetFetchDescriptor)
            let result = widgets.filter { $0.templateKind == WidgetTemplateKind.widgetInstance.rawValue && $0.size == .medium }.map { widgettemplatemodel in
                widgettemplatemodel.toMedium()
            }

            Logging.shared.debug("result: \(result)")
            return result
        } catch {
            Logging.shared.error("Failed to fetch widgets: \(error)")
        }

        return []
    }

//    @MainActor
//    public static func fetchLargeWidget() -> [WidgetEntityQueryLarge] {
//        let modelContainer = WidgetModelHelper.container
//
//        let widgetFetchDescriptor = FetchDescriptor<WidgetTemplateModel>()
//
//        do {
//            let widgets = try modelContainer.mainContext.fetch(widgetFetchDescriptor)
//            let result = widgets.filter { $0.templateKind == WidgetTemplateKind.widgetInstance.rawValue && $0.size == .large }.map { widgettemplatemodel in
//                widgettemplatemodel.toLarge()
//            }
//
//            Logging.shared.debug("result: \(result)")
//            return result
//        } catch {
//            Logging.shared.error("Failed to fetch widgets: \(error)")
//        }
//
//        return []
//    }

    public static func getModelContainer(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = false) -> ModelContainer {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))

        let sharedModelContainer: ModelContainer = {
            let schema = Schema(types)
            // groupContainer: .identifier("group.top.lemonapp.event")
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()

        return sharedModelContainer
    }

    public static let container = getModelContainer([Tag.self, EventModel.self, EventBackupModel.self, WidgetTemplateModel.self], isStoredInMemoryOnly: false)

    @MainActor
    public static func getWidgetTemplates() -> [WidgetTemplateModel] {
        let modelContainer = WidgetModelHelper.container

        let descriptor = FetchDescriptor<WidgetTemplateModel>()

        do {
            let templates = try modelContainer.mainContext.fetch(descriptor)
            return templates
        } catch {
            fatalError()
        }
    }

    @MainActor
    func getTags() -> [Tag] {
        let modelContainer = WidgetModelHelper.container

        let descriptor = FetchDescriptor<Tag>()

        do {
            let tags = try modelContainer.mainContext.fetch(descriptor)
            return tags
        } catch {
            fatalError()
        }
    }

//    @MainActor
//    public static func fetchWidgetTemplate(for eventId: UUID, size: WidgetSize = .small) -> WidgetTemplate? {
//        let modelContainer = WidgetModelHelper.container
//
    ////        let eventId = eventModel.id
//
//        // Fetch widget template using event ID
//        let eventFetchDescriptor = FetchDescriptor<EventModel>(predicate: #Predicate { $0.id == eventId })
//        do {
//            let fetchedEvents = try modelContainer.mainContext.fetch(eventFetchDescriptor)
//            if let targetEvent = fetchedEvents.first {
//                if targetEvent.widgetTemplateModel?.size == size {
//                    return targetEvent.widgetTemplateModel?.toWidgetTemplate()
//                }
//            }
//        } catch {
//            print("Failed to fetch widget template for event ID \(eventId): \(error.localizedDescription)")
//        }
//
//        return nil
//    }
}

extension WidgetTemplateModel {
    func toSmall() -> WidgetEntityQuerySmall {
        if let event, let eventBackup {
            Logging.widgetEntries.debug("event: \(event) \n eventBackup: \(eventBackup)")
        }

        if let eventBackup {
            return WidgetEntityQuerySmall(
                id: eventBackup.id,
                widgetTemplateUUID: uuid,
                widgetTitle: title,
                eventTitle: eventBackup.title,
                endDate: eventBackup.endDate,
                nextStartDate: eventBackup.nextStartDate,
                nextEndDate: eventBackup.nextEndDate,
                isRepeatEnabled: eventBackup.isRepeatEnabled,
                isAllDayEvent: eventBackup.isAllDayEvent,
                jsonData: jsonData
            )
        }
        fatalError("")
    }

    func toMedium() -> WidgetEntityQueryMedium {
        if let event, let eventBackup {
            Logging.widgetEntries.debug("event: \(event) \n eventBackup: \(eventBackup)")
        }

        if let eventBackup {
            return WidgetEntityQueryMedium(
                id: eventBackup.id,
                widgetTemplateUUID: uuid,
                widgetTitle: title,
                eventTitle: eventBackup.title,
                endDate: eventBackup.endDate,
                nextStartDate: eventBackup.nextStartDate,
                nextEndDate: eventBackup.nextEndDate,
                isRepeatEnabled: eventBackup.isRepeatEnabled,
                isAllDayEvent: eventBackup.isAllDayEvent,
                jsonData: jsonData
            )
        }
        fatalError("")
    }

//    func toLarge() -> WidgetEntityQueryLarge {
//        if let event, let eventBackup {
//            Logging.widgetEntries.debug("event: \(event) \n eventBackup: \(eventBackup)")
//        }
//
//        if let eventBackup {
//            return WidgetEntityQueryLarge(
//                id: eventBackup.id,
//                widgetTemplateUUID: uuid,
//                widgetTitle: title,
//                eventTitle: eventBackup.title,
//                endDate: eventBackup.endDate,
//                nextStartDate: eventBackup.nextStartDate,
//                nextEndDate: eventBackup.nextEndDate,
//                isRepeatEnabled: eventBackup.isRepeatEnabled,
//                isAllDayEvent: eventBackup.isAllDayEvent,
//                jsonData: jsonData
//            )
//        }
//        fatalError("")
//    }
}
