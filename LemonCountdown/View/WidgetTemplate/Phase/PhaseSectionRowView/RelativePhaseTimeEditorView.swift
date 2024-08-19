//
//  RelativePhaseTimeEditorView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import LemonCountdownModel
import SwiftUI

// MARK: - RelativePhaseTimeEditorView

struct RelativePhaseTimeEditorView: View {
    let config: PhaseSectionRowConfiguration
    @Bindable var phase: WidgetPhase

    var body: some View {
        let currentDate = Date()
        let date = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: currentDate)!
        let startDate = date.addingTimeInterval(config.prevEndTimeOffset.toTimeInterval())
        let endDate = date.addingTimeInterval(phase.phaseTimeRule.endTimeOffset)

        VStack {
            if config.prevEndTimeOffset.isMax {
                Text("请修改上一个画面的结束时间，否则此画面将不会显示")
                    .foregroundStyle(.red)
            }

            if !phase.phaseTimeRule.endTimeOffset_.isMax && endDate <= startDate {
                Text("时间不符合规则, 此画面的开始时间应该大于上一个画面的结束时间")
                    .foregroundStyle(.red)
            }

            TimeOffsetPickerView(timeOffset: $phase.phaseTimeRule.endTimeOffset_, units: [.hour, .minute])
        }
    }
}
