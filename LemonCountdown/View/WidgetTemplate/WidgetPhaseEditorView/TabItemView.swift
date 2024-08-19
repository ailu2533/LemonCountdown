//
//  TabItemView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI


struct TabItemView: View {
    var title: LocalizedStringKey

    init(title: LocalizedStringKey) {
        self.title = title
    }

    var body: some View {
        Text(title)
    }
}
