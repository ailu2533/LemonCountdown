//
//  TagSelectionMenu.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

struct TagSelectionMenu: View {
    @Binding var selectedTagUUID: UUID?

    @Query(sort: \Tag.sortValue) private var tags: [Tag] = []

    private var selectedTagTitle: String {
        selectedTagUUID.flatMap { uuid in
            tags.first { $0.uuid == uuid }?.title
        } ?? allTagTitle
    }

    var body: some View {
        Menu {
            TagButton(title: allTagTitle, isSelected: selectedTagUUID == nil) {
                selectedTagUUID = nil
            }

            ForEach(tags) { tag in
                TagButton(title: tag.title, isSelected: selectedTagUUID == tag.uuid) {
                    selectedTagUUID = tag.uuid
                }
            }
        } label: {
            HStack {
                Image(systemName: "line.3.horizontal.decrease")
                Text(selectedTagTitle)
            }
        }
        .labelStyle(.titleAndIcon)
    }
}

private struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: isSelected ? "checkmark.square" : "square")
                .fontWeight(.semibold)
        }
    }
}
