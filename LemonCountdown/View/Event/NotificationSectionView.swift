//
//  NotificationSectionView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import LemonCountdownModel
import SwiftUI

struct NotificationSectionView: View {
//    @Binding var isNotificationEnabled: Bool
//    @Binding var firstNotification: EventNotification
//    @Binding var secondNotification: EventNotification
//    var isAllDayEvent: Bool

    @Bindable var cb: EventBuilder

    var body: some View {
        Section {
            Toggle("提醒", isOn: $cb.isNotificationEnabled)
            if cb.isNotificationEnabled {
                NotificationPickerView(text: "第一次提醒", allDay: cb.isAllDayEvent, notification: $cb.firstNotification)
            }

            if cb.isNotificationEnabled && cb.firstNotification != .none {
                NotificationPickerView(text: "第二次提醒", allDay: cb.isAllDayEvent, notification: $cb.secondNotification)
            }
        }
    }
}
