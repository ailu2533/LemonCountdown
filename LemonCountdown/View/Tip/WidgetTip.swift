//
//  WidgetTip.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/17.
//

@preconcurrency import LemonCountdownModel
import TipKit

//// 定义时间阶段的枚举
// enum WidgetPhaseTimeKind {
//    case beforeTargetDate
//    case dayOfEventBeforeStart
//    case dayOfEventDuring
//    case dayOfEventAfterEnd
//    case afterTargetDate
// }

// case taskStartDateBefore = 1
// case taskStartDateAndStartTimeDuring = 2
// case taskStartTimeAndEndTimeDuring = 3
// case endTimeAndTaskEndDateDuring = 4
// case taskEndDateAfter = 5

// 重构后的 WidgetTip 结构体
struct WidgetTip: Tip {
    var timing: PhaseTimeKind

    var title: Text {
        switch timing {
        case .taskStartDateBefore:
            return Text("")
        case .taskStartDateAndStartTimeDuring:
            return Text("")
        case .taskStartTimeAndEndTimeDuring:
            return Text("")
        case .endTimeAndTaskEndDateDuring:
            return Text("")
        case .taskEndDateAfter:
            return Text("")
        }
    }

    var message: Text? {
        switch timing {
        case .taskStartDateBefore:
            return Text("此阶段覆盖从现在到目标日期之前的所有时间。")
        case .taskStartDateAndStartTimeDuring:
            return Text("此阶段涵盖目标日期当天，事件开始前的时间。")
        case .taskStartTimeAndEndTimeDuring:
            return Text("此阶段为事件进行中的时间。您可以进一步细分此阶段，让小组件展示每个子阶段的不同画面。")
        case .endTimeAndTaskEndDateDuring:
            return Text("此阶段开始于事件结束后，持续至目标日期结束。")
        case .taskEndDateAfter:
            return Text("此阶段包括目标日期之后的所有时间。")
        }
    }
}
