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

struct EventDayView2: View {
    let event: Int

    var body: some View {
        if event == 0 {
            Text("今天")
                .font(.system(size: 50))
                .foregroundStyle(.green.opacity(0.6))
        } else if event > 0 {
            if event == 1 {
                Text("明天")
                    .font(.system(size: 50))
            } else {
                Text(event.formatted())
                    .font(.system(size: 50))
                Text("天后")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } else {
            if -event == 1 {
                Text("昨天")
                    .font(.system(size: 50))
            } else {
                Text((-event).formatted())
                    .font(.system(size: 50))
                Text("天前")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
