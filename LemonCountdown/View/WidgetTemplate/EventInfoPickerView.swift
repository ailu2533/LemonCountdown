//
//  EventInfoPicker.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import LemonCountdownModel
import SwiftUI

struct MaxHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct EventInfoPickerView: View {
    var tapCallback: (EventInfoKind) -> Void
    var wigetPhaseTimeKind: PhaseTimeKind

    @State private var maxHeight: CGFloat?

    var body: some View {
        ScrollView {
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]

            Text("选中事件信息后，可以切换到文本 Tab 改变颜色，和字体大小")
                .padding(.horizontal)
                .font(.caption)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(EventInfoKind.getAvailableCasesFor(kind: wigetPhaseTimeKind)) { eventInfo in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            tapCallback(eventInfo)
                        }
                    }) {
                        Text(eventInfo.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: maxHeight)
                            .background(Color.beige)
                            .cornerRadius(20)
                            .shadow(radius: 1.6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: MaxHeightPreferenceKey.self, value: geometry.size.height)
                    })
                }
            }
            .padding()
            .onPreferenceChange(MaxHeightPreferenceKey.self) { value in
                maxHeight = value
            }
        }.scrollIndicators(.hidden)
    }
}
