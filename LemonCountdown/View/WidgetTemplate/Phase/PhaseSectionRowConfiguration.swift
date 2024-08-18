//
//  PhaseSectionRowConfiguration.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonDateUtils
import LemonUtils

struct PhaseSectionRowConfiguration {
    var widgetSize: CGSize
    var enableModify: Bool
    var showTime: Bool
    var isLastRowInSection: Bool

    var startDate: Date?
    var endDate: Date?
    var prevEndTimeOffset: TimeOffset
    var nextEndTimeOffset: TimeOffset
    var currentEndTimeOffset: TimeOffset
    var useRelativeTimeEditor: Bool

    var onTap: () -> Void
    var onDelete: (() -> Void)?

    class Builder {
        private var widgetSize: CGSize = .zero
        private var enableModify = false
        private var showTime = false
        private var isLastRowInSection = false
        // section 的开始和结束时间
        private var startDate: Date?
        private var endDate: Date?
        private var prevEndTimeOffset = TimeOffset()
        private var nextEndTimeOffset = TimeOffset()
        private var currentEndTimeOffset = TimeOffset()
        private var useRelativeTimeEditor = true
        private var onTap: () -> Void = {}
        private var onDelete: (() -> Void)?

        func setWidgetSize(_ size: CGSize) -> Builder {
            widgetSize = size
            return self
        }

        func setEnableModify(_ modify: Bool) -> Builder {
            enableModify = modify
            return self
        }

        func setShowTime(_ show: Bool) -> Builder {
            showTime = show
            return self
        }

        func setIsLastRowInSection(_ last: Bool) -> Builder {
            isLastRowInSection = last
            return self
        }

        func setStartDate(_ date: Date?) -> Builder {
            startDate = date
            return self
        }

        func setEndDate(_ date: Date?) -> Builder {
            endDate = date
            return self
        }

        func setPrevEndTimeOffset(_ offset: TimeOffset) -> Builder {
            prevEndTimeOffset = offset
            return self
        }

        func setNextEndTimeOffset(_ offset: TimeOffset) -> Builder {
            nextEndTimeOffset = offset
            return self
        }

        func setCurrentEndTimeOffset(_ offset: TimeOffset) -> Builder {
            currentEndTimeOffset = offset
            return self
        }

        func setUseRelativeTimeEditor(_ use: Bool) -> Builder {
            useRelativeTimeEditor = use
            return self
        }

        func setOnTap(_ onTap: @escaping () -> Void) -> Builder {
            self.onTap = onTap
            return self
        }

        func setOnDelete(_ onDelete: @escaping () -> Void) -> Builder {
            self.onDelete = onDelete
            return self
        }

        func build() -> PhaseSectionRowConfiguration {
            return PhaseSectionRowConfiguration(widgetSize: widgetSize,
                                                enableModify: enableModify,
                                                showTime: showTime,
                                                isLastRowInSection: isLastRowInSection,
                                                startDate: startDate,
                                                endDate: endDate,
                                                prevEndTimeOffset: prevEndTimeOffset,
                                                nextEndTimeOffset: nextEndTimeOffset,
                                                currentEndTimeOffset: currentEndTimeOffset,
                                                useRelativeTimeEditor: useRelativeTimeEditor,
                                                onTap: onTap,
                                                onDelete: onDelete)
        }
    }
}
