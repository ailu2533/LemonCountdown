//
//  TabEventList.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/2.
//

import Defaults
import LemonCountdownModel
import SwiftData
import SwiftUI

// 排序
// 还未发生的 按照距离开始日期排序， 距离开始日期越小越靠前
// 已经发生的 按照开始日期排序， 开始日期越大越靠前

struct TopLevelEventListView: View {
    @Environment(ViewModel.self) private var vm
    @State private var isAddEventPresented = false
    @State private var selectedEvent: EventModel?
    @Query private var events: [EventModel] = []
    @Default(.selectedTagUUID) var selectedTagUUID

    let showAddButton: Bool
    let navigationTitle: String

    init(showAddButton: Bool = true, navigationTitle: String? = nil) {
        self.showAddButton = showAddButton
        self.navigationTitle = navigationTitle ?? Date().formatted(date: .abbreviated, time: .omitted)
    }

    private var filteredEvents: [EventModel] {
        selectedTagUUID.flatMap { tagUUID in
            events.filter { $0.tag?.uuid == tagUUID }
        } ?? events
    }

    var body: some View {
        NavigationStack {
            SortedEventListView(events: filteredEvents, onTapEvent: { selectedEvent = $0 })
                .navigationTitle(navigationTitle)
                .toolbar {
                    toolbarContent
                }
                .sheet(isPresented: $isAddEventPresented) {
                    EventEditorView()
                }
                .sheet(item: $selectedEvent) { event in
                    EventEditorView(event: event)
                }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            TagSelectionMenu(selectedTagUUID: $selectedTagUUID)
        }
        if showAddButton {
            ToolbarItem(placement: .topBarTrailing) {
                AddEventButton(isAddEventPresented: $isAddEventPresented)
            }
        }
    }
}
