//
//  CreateWidgetTip.swift
//  LemonCountdown
//
//  Created by ailu on 2024/6/6.
//

import Foundation
import TipKit

struct CreateWidgetTip: Tip {
    var title: Text {
        Text("创建小组件")
    }

    var message: Text? {
        Text("创建小组件前，请先创建事件")
    }

    var image: Image? {
        Image(systemName: "lightbulb")
    }
}
