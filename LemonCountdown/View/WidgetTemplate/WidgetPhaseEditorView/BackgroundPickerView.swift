//
//  BackgroundPickerView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import SwiftUI
import LemonCountdownModel
import LemonUtils

// View for selecting a background color or gradient for the phase.
struct BackgroundPickerView: View {
    var selectedBackgroundKind: BackgroundKind
    @Bindable var background: Background

    var body: some View {
        switch selectedBackgroundKind {
        case .morandiColors:
            ColorPickerView2(selection: Binding(get: {
                background.backgroundColor ?? ""
            }, set: { newColor in
                background.kind = .morandiColors
                background.backgroundColor = newColor
                Logging.bg.debug("new color: \(newColor)")
            }), colorSet: ColorSets.morandiColors)
        case .macaronColors:
            ColorPickerView2(selection: Binding(get: {
                background.backgroundColor ?? ""
            }, set: { newColor in
                background.kind = .macaronColors
                background.backgroundColor = newColor
            }), colorSet: ColorSets.macaronColors)
        case .linearGredient:
            LinearGradientPicker(selection: Binding(get: {
                background.linearGradient ?? []
            }, set: { newColor in
                background.kind = .linearGredient
                background.linearGradient = newColor
            }))
        }
    }
}
