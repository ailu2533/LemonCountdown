//
//  AddEventButton.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI

struct AddEventButton: View {
    @Binding var isAddEventPresented: Bool

    var body: some View {
        Button(action: {
            isAddEventPresented = true
        }) {
            Image(systemName: "calendar.badge.plus")
        }
    }
}
