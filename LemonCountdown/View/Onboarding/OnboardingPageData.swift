//
//  MockData.swift
//  OnboardingTest
//
//  Created by ailu on 2024/5/18.
//

import SwiftUI
import UIKit

struct PageData {
    let title: LocalizedStringKey
    let header: LocalizedStringKey
    let content: LocalizedStringKey
    let imageName: String?
    let color: Color
    let textColor: Color
}

struct MockData {
    static let pages: [PageData] = [
        PageData(
            title: "创建纪念日",
            header: "Step 1",
            content: "选择一个特别的日子，记录下来。为其添加标签以方便分类和查找，并设置重复模式，如每年、每月或自定义频率，确保不错过每一个重要时刻。",
            imageName: nil,
            color: Color(hex: "F2EA72"),
            textColor: Color(hex: "05131C")),
        PageData(
            title: "为重要的日子设置提醒",
            header: "Step 2",
            content: "设定提前提醒，并将事件及提醒配置写入到您的日历应用中。利用日历的稳定可靠的提醒功能，确保您不会错过任何重要的日子。",
            imageName: nil,
            color: Color(hex: "2FE0ED"),
            textColor: Color(hex: "05131C")),
        PageData(
            title: "创建小组件",
            header: "Step 3",
            content: "自定义小组件模板，根据事件的时间范围分为五个阶段, 每个阶段可以定制不同的画面",
            imageName: nil,
            color: Color(hex: "E6D5A1"),
            textColor: Color(hex: "05131C")),

        PageData(
            title: "定制小组件 1",
            header: "Step 4",
            content: "例如，你有一个重要的考试事件（目标日期是5月28日，开始时间10:00，结束时间18:00），第一个段阶段是5月28日之前，您可以设置考试前的倒计时，让小组件显示距离考试的天数。",
            imageName: "s1",
            color: Color(hex: "ED719D"),
            textColor: Color(hex: "05131C")),
        PageData(
            title: "定制小组件 2",
            header: "Step 5",
            content: "第二阶段是5月28日的10点之前，即考试前几小时。您可以让小组件显示自定义的文字，比如显示准备事项，需携带的物品。",
            imageName: "s2",
            color: Color(hex: "F2EA72"),
            textColor: Color(hex: "05131C")),

        PageData(
            title: "定制小组件 3",
            header: "Step 6",
            content: "第三阶段是5月28日的10点 到 18 点之间，即处于事件中的阶段，您可以将这个阶段划分为时间范围更小的子阶段，如上午考试、中午休息、下午考试，每个时段定制不同画面。",
            imageName: "s3",
            color: Color(hex: "ED8E2F"),
            textColor: Color(hex: "05131C")),
        PageData(
            title: "定制小组件 4",
            header: "Step 7",
            content: "第四阶段是5月28日的18点后，即当天考试结束后。您可以让小组件提醒收拾个人物品。",
            imageName: "s4",
            color: Color(hex: "D2AF93"),
            textColor: Color(hex: "05131C")),
        PageData(
            title: "定制小组件 5",
            header: "Step 8",
            content: "第五阶段是5月28日后，您可以让小组件显示已过天数，帮助回顾和放松。",
            imageName: "s5",
            color: Color(hex: "388712"),
            textColor: Color(hex: "05131C"))
    ]
}

/// Color converter from hex string to SwiftUI's Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF

        self.init(red: Double(r) / 0xFF, green: Double(g) / 0xFF, blue: Double(b) / 0xFF)
    }
}
