//
//  EventDayView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/20.
//

import SwiftUI

struct EventDayView: View {
    let event: Int

    var body: some View {
        if event == 0 {
            Text("今天")
                .foregroundStyle(.black)
        } else if event > 0 {
            if event == 1 {
                Text("明天")
            } else {
                Text(event.formatted())
                Text("天后")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } else {
            if -event == 1 {
                Text("昨天").foregroundStyle(.secondary)
            } else {
                Text((-event).formatted()).foregroundStyle(.secondary)
                Text("天前")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

