//
//  PhaseSectionConfiguration.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonCountdownModel
import LemonDateUtils
import LemonUtils
import SwiftUI

public struct PhaseSectionConfiguration {
    public var title: String // The title of the phase section, localized.
    public var addLabel: String // Label for the add button.
    public var widgetSize: CGSize // The size of the widget.
    public var timing: PhaseTimeKind! // Timing type of the event.
    public var showAddButton: Bool // Flag to determine if the add button should be shown.
    public var lastEndTime: TimeOffset? // Optional time offset marking the end of the last phase.
    public var showTime: Bool // Flag to determine if the time should be shown.
    public var isLast: Bool // Flag to determine if this is the last phase section.
//    var kind: WidgetPhaseTimeKind

    public var startDate: Date?
    public var endDate: Date?
    // 使用相对时间编辑phase
    public var useRelatvieTime: Bool

    private init(builder: Builder) {
        title = builder.title
        addLabel = builder.addLabel
        widgetSize = builder.widgetSize
        timing = builder.timing
        showAddButton = builder.showAddButton
        lastEndTime = builder.lastEndTime
        showTime = builder.showTime
        isLast = builder.isLast
        startDate = builder.startDate
        endDate = builder.endDate
        useRelatvieTime = builder.useRelatvieTime
//        kind = builder.kind
    }

    class Builder {
        var title = ""
        var addLabel = ""
        var widgetSize: CGSize = .zero
        var timing: PhaseTimeKind?
        var showAddButton = false
        var lastEndTime: TimeOffset?
        var showTime = false
        var isLast = false
        var startDate: Date?
        var endDate: Date?
        var useRelatvieTime = true

        func setTitle(_ title: String) -> Builder {
            self.title = title
            return self
        }

        func setAddLabel(_ label: String) -> Builder {
            addLabel = label
            return self
        }

        func setWidgetSize(_ size: CGSize) -> Builder {
            widgetSize = size
            return self
        }

        func setTiming(_ timing: PhaseTimeKind) -> Builder {
            self.timing = timing
            return self
        }

        func setShowAddButton(_ show: Bool) -> Builder {
            showAddButton = show
            return self
        }

        func setLastEndTime(_ timeOffset: TimeOffset?) -> Builder {
            lastEndTime = timeOffset
            return self
        }

        func setShowTime(_ show: Bool) -> Builder {
            showTime = show
            return self
        }

        func setIsLast(_ isLast: Bool) -> Builder {
            self.isLast = isLast
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

        func setUseRelativeTime(_ useRelativeTime: Bool) -> Builder {
            useRelatvieTime = useRelativeTime
            return self
        }

//        func setKind(_ kind: WidgetPhaseTimeKind) -> Builder {
//            self.kind = kind
//            return self
//        }

        func build() -> PhaseSectionConfiguration {
            guard timing != nil else {
                fatalError("Timing must be set before building.")
            }
            return PhaseSectionConfiguration(builder: self)
        }
    }
}
