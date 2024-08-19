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

let allTagTitle = String(localized: "全部事件")

struct EventListView: View {
    @State private var addEventSheet = false
    @State private var tappedEvent: EventModel?
    @Query(sort: \Tag.sortValue) private var tags: [Tag] = []
    @Query private var events: [EventModel] = []
    @Default(.selectedTagUUID) var selectedTagUUID

    let showAddButton: Bool
    let navigationTitle: String

    private var filteredEvents: [EventModel] {
        selectedTagUUID.flatMap { tagUUID in
            events.filter { $0.tag?.uuid == tagUUID }
        } ?? events
    }

    var body: some View {
        SortedEventListView(events: filteredEvents, onTapEvent: { tappedEvent = $0 })
            .sheet(isPresented: $addEventSheet) {
                EventEditorView()
            }
            .sheet(item: $tappedEvent) { event in
                EventEditorView(event: event)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    TagSelectionMenu(selectedTagUUID: $selectedTagUUID, tags: tags)
                }
                if showAddButton {
                    ToolbarItem(placement: .topBarTrailing) {
                        AddEventButton(addEventSheet: $addEventSheet)
                    }
                }
            }
    }
}