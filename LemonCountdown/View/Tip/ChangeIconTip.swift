//
//  ChangeIconTip.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/15.
//

import Foundation
import TipKit

struct ChangeIconTip: Tip {
    var title: Text {
        Text("修改图标")
    }

    var message: Text? {
        Text("点击下方图片可以修改图标")
    }

    var image: Image? {
        Image(systemName: "star")
    }

    var options: [Option] {
        Tips.MaxDisplayCount(10)
    }
}
