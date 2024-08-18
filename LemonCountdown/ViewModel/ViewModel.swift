//
//  ViewModel.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import Foundation
import SwiftData

import DateHelper
import LemonCountdownModel
// import iCalendarParser
import SwiftUI

@Observable
class ViewModel {
    var modelContext: ModelContext

    var eventNavigationPath: NavigationPath
    var widgetNavigationPath: NavigationPath

    var eventVersion = 0
    var tagVersion = 0
    var widgetListVersion = 0

    @ObservationIgnored
    var odrRequest: NSBundleResourceRequest?

    var events: [EventModel] = []

//    var todayEvents: [EventModel] = []
//    var futureEvents: [EventModel] = []
//    var pastEvents: [EventModel] = []

    var showSelectedEventSheet = false

    typealias Callback = () -> Void

    var sheetDismissCallback: Callback?

//    var tags: [Tag] = []
//    var widgetTemplateModels: [WidgetTemplateModel] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        eventNavigationPath = NavigationPath()
        widgetNavigationPath = NavigationPath()
    }

    func deleteWidgetPhase(_ phase: WidgetPhase) {
    }
}
