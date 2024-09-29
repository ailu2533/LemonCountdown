//
//  EventBackupSheetView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonCountdownModel

// New subviews
struct EventBackupSheetView: View {
    let eventBackup: EventBackupModel?

    var body: some View {
        Group {
            if let eventBackup = eventBackup {
                EventBackupView(eventBackup: eventBackup)
            } else {
                EmptyView()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
