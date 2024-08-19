//
//  TagSectionView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

struct TagSectionView: View {
    @Bindable var cb: EventBuilder

    @Environment(ViewModel.self) private var vm

    @Query(sort: \Tag.sortValue) private var tags: [Tag] = []

    var body: some View {
        Section {
            Picker(selection: $cb.tag) {
                Text("无").tag(nil as Tag?)
                Divider()
                ForEach(tags) { tag in
                    Text(tag.title).tag(tag as Tag?)
                }
            } label: {
                Text("标签")
            }

            NavigationLink {
                TagManagementView()
            } label: {
                Text("标签管理")
            }
        }
    }
}
