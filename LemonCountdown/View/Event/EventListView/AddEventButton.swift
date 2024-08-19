//
//  AddEventButton.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI

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
