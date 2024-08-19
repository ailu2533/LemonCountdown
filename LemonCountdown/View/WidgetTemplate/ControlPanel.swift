//
//  ControlPanel.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import HorizontalPicker
import LemonCountdownModel
import SwiftUI

struct ControlPanel: View {
    @Binding var selectedControl: Control
    @Binding var selectedSticker: String
    @Binding var showInputText: Bool
    @Binding var selectedBackgroundKind: BackgroundKind

    var body: some View {
        switch selectedControl {
        case .sticker:
            HorizontalSelectionPicker(items: stickerMap.keys.elements, selectedItem: $selectedSticker) { stickerName in
                Text(stickerName)
            }

        case .text:

            HStack {
                Spacer()
                Button {
                    showInputText = true
                } label: {
                    Text("输入文字")
                }
                .padding(.horizontal, 12)
//                .buttonStyle(HorizontalPickerButtonStyle(isSelected: true))
            }

        case .eventInfo:
            HStack {}
        case .background:
            HorizontalSelectionPicker(items: BackgroundKind.allCases, selectedItem: $selectedBackgroundKind) { backgroundKind in
                Text(backgroundKind.text).tag(backgroundKind)
            }
        }
    }
}

#Preview {
    ControlPanel(selectedControl: .constant(.background), selectedSticker: .constant("hello"), showInputText: .constant(true), selectedBackgroundKind: .constant(.linearGredient))
}
