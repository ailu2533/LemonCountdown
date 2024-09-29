//
//  Control.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import HorizontalPicker
import LemonCountdownModel
import SwiftMovable
import SwiftUI

enum Control: Int, Hashable, CaseIterable {
    case sticker
    case text
    case background
    case eventInfo

    var text: LocalizedStringKey {
        switch self {
        case .background: return "背景"
        case .sticker: return "贴纸"
        case .text: return "文字"
        case .eventInfo: return "事件信息"
        }
    }

    @ViewBuilder
    func view(vm: WidgetPhaseEditorViewModel, phase: WidgetPhase) -> some View {
        @Bindable var vm = vm

        switch self {
        case .background:
            BackgroundPickerView(selectedBackgroundKind: vm.selectedBackgroundKind, background: phase.background)
        case .sticker:
            SingleIconSetIconPickerView(selectedImg: $vm.selectedImage, icons: stickerMap[vm.selectedSticker] ?? [], tapCallback: vm.addSticker)
        case .text:
            TextStyleEditor(textItem: Binding(
                get: { vm.selection as? Stylable },
                set: { newValue in
                    if var selected = vm.selection as? Stylable {
                        if let colorHex = newValue?.colorHex {
                            selected.colorHex = colorHex
                        }
                        selected.fontName = newValue?.fontName
                        if let fontSize = newValue?.fontSize {
                            selected.fontSize = fontSize
                        }
                    }
                }), selectedFontName: .constant(vm.selectedFontName), fontSize: .constant(vm.fontSize))
        case .eventInfo:
            EventInfoPickerView(tapCallback: vm.addEventInfo, wigetPhaseTimeKind: phase.kind)
        }
    }
}
