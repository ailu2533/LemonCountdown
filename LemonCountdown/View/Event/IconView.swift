//
//  IconView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/13.
//

import SwiftUI

struct IconView: View {
    @Binding var showSheet: Bool
    var colorHex: String
    var icon: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: colorHex) ?? Color.clear)
                .frame(width: 70, height: 70)

            Image(icon).resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
        .onTapGesture {
            showSheet = true
        }
    }
}
