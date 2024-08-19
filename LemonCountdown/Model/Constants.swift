//
//  Constants.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import SwiftUI

let weekDays: [(LocalizedStringKey, UInt8)] = [
    ("星期一", 1),
    ("星期二", 2),
    ("星期三", 4),
    ("星期四", 8),
    ("星期五", 16),
    ("星期六", 32),
    ("星期日", 64),
]

let localizedWeekDays = [String(localized: "星期一", bundle: .main),
                         String(localized: "星期二", bundle: .main),
                         String(localized: "星期三", bundle: .main),
                         String(localized: "星期四", bundle: .main),
                         String(localized: "星期五", bundle: .main),
                         String(localized: "星期六", bundle: .main),
                         String(localized: "星期日", bundle: .main)]

let allTagTitle = String(localized: "全部事件")

let defaultFillStyle = AnyShapeStyle(LinearGradient(colors: [.blue, .blue.opacity(0.6), .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
