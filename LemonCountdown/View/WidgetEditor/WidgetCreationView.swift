//
//  CreateWidgetView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

struct ChoseWidgetTemplateNavigation: Hashable {
    var eventBackupModel: EventBackupModel
    var eventModel: EventModel
}

struct WidgetCreationView: View {
    @Environment(ViewModel.self)
    private var vm

    @Query(sort: \Tag.sortValue)
    private var tags: [Tag] = []

    @State private var addEventSheet = false
    @State private var tappedEvent: EventModel?
    @Query private var events: [EventModel] = []
    @State private var selectedTag: String?
    @State private var navigationPath = NavigationPath()

    var filteredEvents: [EventModel] {
        Logging.shared.debug("filteredEvents \(selectedTag ?? "All")")
        return selectedTag.map { tag in events.filter { $0.tag?.title == tag } } ?? events
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            SortedEventListView(events: filteredEvents, onTapEvent: { event in
                let eventBackup = vm.createBackupFromEvent(event)

                navigationPath.append(ChoseWidgetTemplateNavigation(eventBackupModel: eventBackup, eventModel: event))
            })

            .navigationTitle("选择事件")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChoseWidgetTemplateNavigation.self, destination: { item in
                WidgetTemplateSelectionView(previewTapCallback: { widgettemplatemodel in
                    let instance = widgettemplatemodel.cloneAsWidgetInstance(event: item.eventModel, eventBackup: item.eventBackupModel)
                    vm.modelContext.insert(instance)

                    vm.sheetDismissCallback = {
                        vm.widgetNavigationPath.append(WidgetTemplateDetailTarget.widgetTemplateModel(instance))
                    }

                    vm.showSelectedEventSheet = false
                })
                .navigationBarBackButtonHidden().toolbar {
                    ToolbarItem {
                        Button {
                            vm.showSelectedEventSheet = false
                        } label: {
                            Text("取消")
                        }
                    }
                }
            })

            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    TagSelectionMenu(selectedTag: $selectedTag, tags: tags)
                }
                ToolbarItem {
                    Button {
                        vm.showSelectedEventSheet = false
                    } label: {
                        Text("取消")
                    }
                }
            })
        }
    }
}
