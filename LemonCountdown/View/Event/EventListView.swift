//
//  TabEventList.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/2.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

// 排序
// 还未发生的 按照距离开始日期排序， 距离开始日期越小越靠前
// 已经发生的 按照开始日期排序， 开始日期越大越靠前

let allTagTitle = String(localized: "全部事件")

struct EventListView: View {
    @Environment(ViewModel.self) private var vm
    @State private var addEventSheet = false
    @State private var tappedEvent: EventModel?
    @Query(sort: \Tag.sortValue) private var tags: [Tag] = []
    @Query private var events: [EventModel] = []
    @AppStorage("selectedTag") var selectedTag: String?
    var showAddButton = true
    var navigationTitle: String // 外部传入的标题

    var filteredEvents: [EventModel] {
        Logging.shared.debug("filteredEvents \(selectedTag ?? "All")")
        return selectedTag.map { tag in events.filter { $0.tag?.title == tag } } ?? events
    }

    var body: some View {
        SortedEventListView(events: filteredEvents, onTapEvent: { event in
            tappedEvent = event
        })
        .sheet(isPresented: $addEventSheet, content: {
            EventEditorView()
        })
        .sheet(item: $tappedEvent, content: { event in
            EventEditorView(event: event)
        })
        .navigationTitle(navigationTitle) // 使用外部传入的标题
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                TagSelectionMenu(selectedTag: $selectedTag, tags: tags)
            }
            if showAddButton {
                ToolbarItem(placement: .topBarTrailing) {
                    AddEventButton(addEventSheet: $addEventSheet)
                }
            }
        })
    }
}

struct SortedEventListView: View {
    var events: [EventModel]
    var onTapEvent: (EventModel) -> Void
    @AppStorage("todayIsExpanded") private var todayIsExpanded = true
    @AppStorage("futureIsExpanded") private var futureIsExpanded = false
    @AppStorage("pastIsExpanded") private var pastIsExpanded = false

    var body: some View {
        let sortedEvents = ViewModel.sort(events: events)
        return List {
            eventSection(title: "今天", events: sortedEvents.0, isExpanded: $todayIsExpanded)
            eventSection(title: "将来", events: sortedEvents.1, isExpanded: $futureIsExpanded)
            eventSection(title: "过去", events: sortedEvents.2, isExpanded: $pastIsExpanded)
        }
        .listStyle(.sidebar)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }

    private func eventSection(title: LocalizedStringKey, events: [EventModel], isExpanded: Binding<Bool>) -> some View {
        Section(title, isExpanded: isExpanded) {
            ForEach(events) { event in
//                EventCardView(
//                    icon: event.icon,
//                    title: event.title,
//                    diffDays: Calendar.current.numberOfDaysBetween(Date(), and: event.nextStartDate),
//                    colorHex: event.colorHex,
//                    eventStartDate: event.nextStartDate,
//                    isRepeat: event.isRepeatEnabled,
//                    enableNotification: event.isNotificationEnabled
//                )

                EventCardView(
                    icon: event.icon,
                    title: event.title,
                    diffDays: Calendar.current.numberOfDaysBetween(Date(), and: Date()),
                    colorHex: event.colorHex,
                    eventStartDate: Date(),
                    isRepeat: event.isRepeatEnabled,
                    enableNotification: event.isNotificationEnabled
                )

                .onTapGesture {
                    onTapEvent(event)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 5))
            }
        }
    }
}

struct TagSelectionMenu: View {
    @Binding var selectedTag: String?
    var tags: [Tag]

    var body: some View {
        Menu {
            Button(action: {
                selectedTag = nil
            }, label: {
                Label(allTagTitle, systemImage: selectedTag == nil ? "checkmark.square" : "square")
            })
            ForEach(tags) { tag in
                Button(action: {
                    selectedTag = tag.title
                }, label: {
                    Label(tag.title, systemImage: selectedTag == tag.title ? "checkmark.square" : "square")
                })
            }
        } label: {
            HStack {
                Image(systemName: "line.3.horizontal.decrease")
                Text(selectedTag ?? allTagTitle)
            }
        }.labelStyle(.titleAndIcon)
    }
}

struct AddEventButton: View {
    @Binding var addEventSheet: Bool

    var body: some View {
        Button(action: {
            addEventSheet = true
        }) {
            Image(systemName: "calendar.badge.plus")
        }
    }
}
