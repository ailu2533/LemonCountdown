//
//  WidgetSizeType.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/14.
//

import Foundation

// Protocol to define a default size
protocol WidgetSizeType {
    static var defaultSize: WidgetSize { get }
}

// Conformances for each size
struct SmallSize: WidgetSizeType {
    static var defaultSize: WidgetSize { .small }
}

struct MediumSize: WidgetSizeType {
    static var defaultSize: WidgetSize { .medium }
}

struct LargeSize: WidgetSizeType {
    static var defaultSize: WidgetSize { .large }
}
