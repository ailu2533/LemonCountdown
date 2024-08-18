//
//  NotificationPickerView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import LemonCountdownModel
import SwiftUI

// MARK: Notification Picker View

struct NotificationPickerView: View {
    var text: LocalizedStringKey
    var allDay: Bool
    @Binding var notification: EventNotification

    var body: some View {
        Picker(text, selection: $notification) {
            // Always include the .none case
            Text(EventNotification.none.text).tag(EventNotification.none)
            Divider()

            // Conditionally include other cases based on `allDay`
            ForEach(allDay ? EventNotification.allCases.filter { $0.isAllDayRelevant || $0 == .none } : EventNotification.allCases.filter { !$0.isAllDayRelevant || $0 == .none }, id: \.self) { notificationCase in
                if notificationCase != .none { // Avoid duplicating the .none case
                    Text(notificationCase.text).tag(notificationCase)
                }
            }
        }
    }
}

extension EventNotification {
    var isAllDayRelevant: Bool {
        switch self {
        case .atDay9AM, .dayBefore9AM, .twoDaysBefore9AM, .weekBefore9AM:
            return true
        default:
            return false
        }
    }
}
