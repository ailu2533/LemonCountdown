//
//  WidgetEditorControlsView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftMovable
import SwiftUI
import PagerTabStripView
import HorizontalPicker

struct WidgetEditorControlsView: View {
    @Binding var selectedControl: Control
    @Binding var selectedSticker: String
    @Binding var showInputText: Bool
    @Binding var selectedBackgroundKind: BackgroundKind
    @Bindable var phase: WidgetPhase
    @Binding var selected: MovableObject?
    @Binding var selectedImage: String
    @Binding var selectedFontName: String?
    @Binding var fontSize: CGFloat
    let addSticker: (String) -> Void
    let addEventInfo: (EventInfoKind) -> Void
    let height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ControlPanel(selectedControl: $selectedControl, selectedSticker: $selectedSticker, showInputText: $showInputText, selectedBackgroundKind: $selectedBackgroundKind)
                .contentMargins(.horizontal, 12)
                .frame(maxHeight: 30)
                .padding(.vertical, 10)

            PagerTabStripView(swipeGestureEnabled: .constant(false), selection: $selectedControl) {
                BackgroundPickerView(selectedBackgroundKind: selectedBackgroundKind, background: phase.background)
                    .pagerTabItem(tag: Control.background) {
                        TabItemView(title: Control.background.text)
                    }
                SingleIconSetIconPickerView(selectedImg: $selectedImage, icons: stickerMap[selectedSticker] ?? [], tapCallback: addSticker)
                    .pagerTabItem(tag: Control.sticker) {
                        TabItemView(title: Control.sticker.text)
                    }
                TextStyleEditor(textItem: Binding(
                    get: { selected as? Stylable },
                    set: { newValue in
                        if var selected = selected as? Stylable {
                            if let colorHex = newValue?.colorHex {
                                selected.colorHex = colorHex
                            }
                            selected.fontName = newValue?.fontName
                            if let fontSize = newValue?.fontSize {
                                selected.fontSize = fontSize
                            }
                        }
                    }), selectedFontName: $selectedFontName, fontSize: $fontSize)
                    .pagerTabItem(tag: Control.text) {
                        TabItemView(title: Control.text.text)
                    }
                EventInfoPickerView(tapCallback: addEventInfo, wigetPhaseTimeKind: phase.kind)
                    .pagerTabItem(tag: Control.eventInfo) {
                        TabItemView(title: Control.eventInfo.text)
                    }
            }
            .contentMargins(.vertical, 30, for: .scrollContent)
            .pagerTabStripViewStyle(BarButtonStyle(tabItemHeight: 36,
                                                   indicatorView: {
                                                       AnyView(Rectangle().fill(Color.accentColor).frame(height: 2))
                                                   }))
            .background(Color(.systemGray6))
            .frame(height: height)
        }
    }
}
