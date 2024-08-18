//
//  MediumWidgets.swift
//  WidgetsExtension
//
//  Created by ailu on 2024/5/14.
//

import SwiftUI
import WidgetKit
import LemonCountdownModel

struct MediumEntry: TimelineEntry {
    let date: Date
    let configuration: MediumConfigurationAppIntent
    var widgetTemplateId: UUID?
    var phase: WidgetPhase?
}

struct MediumWidgetsEntryView: View {
    var entry: MediumProvider.Entry
    var widgetSize: CGSize

    var widgetURL: URL {
        if let widgetTemplateId = entry.widgetTemplateId {
            return URL(string: "myapp://\(widgetTemplateId.uuidString)")!
        }
        return URL(string: "myapp://tutorial")!
    }

    var body: some View {
        if let phase = entry.phase {
            // 从 view identity 的角度而言，切换 phase 后，原来的 view state 需要改变。
            // 为了让 state 改变，就要加 explicit view id，使原来的 view 销毁，重建新的 view。
            WidgetCardView(phase: phase, widgetSize: widgetSize)
                .id(entry.phase?.id)
                .widgetURL(widgetURL)
        } else {
            ZStack {
                LinearGradient(colors: [Color.c1, Color.c2], startPoint: .leading, endPoint: .trailing)

                VStack(alignment: .leading) {
                    Text("1. 长按进入编辑模式")
                    Text("2. 点击[编辑小组件]")
                    Text("3. 选择要展示的小组件")
                }
            }
        }
    }
}

struct MediumWidget: Widget {
    let kind: String = "MediumWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MediumConfigurationAppIntent.self, provider: MediumProvider()) { entry in
            MediumWidgetsEntryView(entry: entry, widgetSize: SizeHelper.getMedium())
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("通用中号小组件")
        .description("首先在[事件Tab]创建事件, 然后在[小组件Tab]为事件创建中号小组件, 然后将小组件添加到桌面")
        .supportedFamilies([.systemMedium])
    }
}

extension MediumEntry: CustomStringConvertible {
    var description: String {
        var desc = "\nMediumEntry\n(date: \(date.formatted())"
        if let widgetTemplateId = widgetTemplateId {
            desc += ", widgetTemplateId: \(widgetTemplateId)"
        }
        if let phase = phase {
            desc += ", phase: \(phase)"
        }
        desc += ")\n"
        return desc
    }
}
