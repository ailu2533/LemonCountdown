//
//  WidgetEditorControlsView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import HorizontalPicker
import LemonCountdownModel
import PagerTabStripView
import SwiftMovable
import SwiftUI

struct WidgetEditorControlsView: View {
    @Bindable var phase: WidgetPhase
    @Bindable var vm: WidgetPhaseEditorViewModel

//    let addSticker: (String) -> Void
//    let addEventInfo: (EventInfoKind) -> Void
    let height: CGFloat

    init(phase: WidgetPhase, vm: WidgetPhaseEditorViewModel, height: CGFloat) {
        self.phase = phase
        self.vm = vm
        self.height = height
    }

    var body: some View {
        VStack(spacing: 0) {
            ControlPanel(selectedControl: $vm.selectedControl, selectedSticker: $vm.selectedSticker, showInputText: $vm.showInputText, selectedBackgroundKind: $vm.selectedBackgroundKind)
                .contentMargins(.horizontal, 12)
                .frame(maxHeight: 30)
                .padding(.vertical, 10)

            PagerTabStripView(swipeGestureEnabled: .constant(false), selection: $vm.selectedControl) {
                BackgroundPickerView(selectedBackgroundKind: vm.selectedBackgroundKind, background: phase.background)
                    .pagerTabItem(tag: Control.background) {
                        TabItemView(title: Control.background.text)
                    }
                SingleIconSetIconPickerView(selectedImg: $vm.selectedImage, icons: stickerMap[vm.selectedSticker] ?? [], tapCallback: vm.addSticker)
                    .pagerTabItem(tag: Control.sticker) {
                        TabItemView(title: Control.sticker.text)
                    }
                TextStyleEditor(textItem: Binding(
                    get: { vm.selected as? Stylable },
                    set: { newValue in
                        if var selected = vm.selected as? Stylable {
                            if let colorHex = newValue?.colorHex {
                                selected.colorHex = colorHex
                            }
                            selected.fontName = newValue?.fontName
                            if let fontSize = newValue?.fontSize {
                                selected.fontSize = fontSize
                            }
                        }
                    }), selectedFontName: $vm.selectedFontName, fontSize: $vm.fontSize)
                    .pagerTabItem(tag: Control.text) {
                        TabItemView(title: Control.text.text)
                    }
                EventInfoPickerView(tapCallback: vm.addEventInfo, wigetPhaseTimeKind: phase.kind)
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
