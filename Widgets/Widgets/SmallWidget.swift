//
//  Widgets.swift
//  Widgets
//
//  Created by ailu on 2024/5/8.
//

import LemonCountdownModel
import SwiftUI
import WidgetKit

public struct SmallEntry: TimelineEntry {
    public let date: Date
    let configuration: SmallConfigurationAppIntent
    let widgetTemplateId: UUID?
    public var phase: WidgetPhase?
}

struct SmallWidgetsEntryView: View {
    var entry: SmallProvider.Entry
    var widgetSize: CGSize

    var widgetURL: URL {
        if let widgetTemplateId = entry.widgetTemplateId {
            return URL(string: "myapp://\(widgetTemplateId.uuidString)")!
        }
        return URL(string: "myapp://tutorial")!
    }

    var body: some View {
        if let phase = entry.phase {
            WidgetCardView(phase: phase, widgetSize: widgetSize)
                .widgetURL(widgetURL)
        } else {
            ZStack {
                LinearGradient(colors: [Color.c1, Color.c2], startPoint: .leading, endPoint: .trailing)
                VStack(alignment: .leading) {
                    Text("1. 长按进入编辑模式")
                    Text("2. 点击[编辑小组件]")
                    Text("3. 选择要展示的小组件")
                }.font(.footnote)
            }
        }
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SmallConfigurationAppIntent.self, provider: SmallProvider()) { entry in
            SmallWidgetsEntryView(entry: entry, widgetSize: SizeHelper.getSmall())
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("通用小号小组件")
        .description("首先在[事件Tab]创建事件, 然后在[小组件Tab]为事件创建小号小组件, 然后将小组件添加到桌面")
        .supportedFamilies([.systemSmall])
    }
}

extension SmallConfigurationAppIntent {
    fileprivate static var smiley: SmallConfigurationAppIntent {
        let intent = SmallConfigurationAppIntent()
        return intent
    }

    fileprivate static var starEyes: SmallConfigurationAppIntent {
        let intent = SmallConfigurationAppIntent()
        return intent
    }
}
