//
//  CornerRadiusModifier.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/7.
//

import Foundation

import SwiftUI

struct RoundedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 1)
    }
}

extension View {
    func roundedWidget() -> some View {
        modifier(RoundedModifier())
    }
}
