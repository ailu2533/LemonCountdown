//
//  Control.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import SwiftUI

// Enum representing different controls for editing the widget.
enum Control: Int, Hashable {
//    case none
    case sticker
    case text
    case background
    case eventInfo

    var text: LocalizedStringKey {
        switch self {
        case .sticker:
            "贴纸"
        case .text:
            "文字"
        case .eventInfo:
            "事件信息"
        case .background:
            "背景"
        }
    }
}
