//
//  SortedEventListView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Defaults
import LemonCountdownModel
import SwiftUI

struct SortedEventListView: View {
    var events: [EventModel]
    var onTapEvent: (EventModel) -> Void

    @Default(.todayIsExpanded) private var todayIsExpanded
    @Default(.futureIsExpanded) private var futureIsExpanded
    @Default(.pastIsExpanded) private var pastIsExpanded

    var body: some View {
        let sortedEvents = ViewModel.sort(events: events)
        return List {
            EventSection(title: "今天", events: sortedEvents.0, isExpanded: $todayIsExpanded, onTapEvent: onTapEvent)
            EventSection(title: "将来", events: sortedEvents.1, isExpanded: $futureIsExpanded, onTapEvent: onTapEvent)
            EventSection(title: "过去", events: sortedEvents.2, isExpanded: $pastIsExpanded, onTapEvent: onTapEvent)
        }
        .listStyle(.sidebar)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

private struct EventSection: View {
    let title: LocalizedStringKey
    let events: [EventModel]
    @Binding var isExpanded: Bool
    let onTapEvent: (EventModel) -> Void

    var body: some View {
        Section(title, isExpanded: $isExpanded) {
            ForEach(events) { event in
                EventRow(event: event, onTapEvent: onTapEvent)
            }
        }
    }
}

private struct EventRow: View {
    let event: EventModel
    let onTapEvent: (EventModel) -> Void

    var body: some View {
        Button(action: {
            onTapEvent(event)
        }, label: {
            EventCardView(
                icon: event.icon,
                title: event.title,
                diffDays: Calendar.current.numberOfDaysBetween(Date(), and: Date()),
                colorHex: event.colorHex,
                eventStartDate: Date(),
                isRepeat: event.isRepeatEnabled,
                enableNotification: event.isNotificationEnabled
            )
        })
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 5))
    }
}
