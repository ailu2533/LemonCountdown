//
//  ColorSectionView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import LemonCountdownModel
import LemonUtils
import SwiftUI

struct ColorSectionView: View {
    @Binding var colorHex: String

    var body: some View {
        DisclosureGroup(
            content: {
                ColorPickerView(selection: $colorHex, colorSet: ColorSets.morandiColors)
                    .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
            },
            label: {
                Text("颜色")
            }
        )
    }
}
