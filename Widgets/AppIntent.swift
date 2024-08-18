//
//  AppIntent.swift
//  Widgets
//
//  Created by ailu on 2024/5/8.
//

import AppIntents
import WidgetKit

// small size 小组件
struct SmallConfigurationAppIntent: WidgetConfigurationIntent, CustomStringConvertible {
    static var title: LocalizedStringResource = "选择事件"
    static var description = IntentDescription("请先在事件编辑页面为事件绑定小号小组件模板")

    @Parameter(title: "小号小组件")
    var event: WidgetEntityQuerySmall?

    var description: String {
        "Small Configuration App Intent with event: \(event?.description ?? "None")"
    }
}

// medium size 中号小组件
struct MediumConfigurationAppIntent: WidgetConfigurationIntent, CustomStringConvertible {
    static var title: LocalizedStringResource = "选择事件"
    static var description = IntentDescription("请先在事件编辑页面为事件绑定中号小组件模板")

    @Parameter(title: "中号小组件")
    var event: WidgetEntityQueryMedium?

    var description: String {
        "Medium Configuration App Intent with event: \(event?.description ?? "None")"
    }
}

//// large size 大号小组件
// struct LargeConfigurationAppIntent: WidgetConfigurationIntent, CustomStringConvertible {
//    static var title: LocalizedStringResource = "Configuration"
//    static var description = IntentDescription("请先在事件编辑页面为事件绑定大号小组件模板")
//
//    @Parameter(title: "大号小组件")
//    var event: WidgetEntityQueryLarge?
//
//    var description: String {
//        "Large Configuration App Intent with event: \(event?.description ?? "None")"
//    }
// }
