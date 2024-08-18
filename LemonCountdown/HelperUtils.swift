//
//  HelperUtils.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/20.
//

import Foundation
import LemonDateUtils
import LemonUtils

extension TimeOffset {
    // 当 isMax

    public var localizedDescription: String {
        var parts: [String] = []
        if year != 0 { parts.append(String(localized: "\(abs(year))年")) }
        if month != 0 { parts.append(String(localized: "\(abs(month))月")) }
        if week != 0 { parts.append(String(localized: "\(abs(week))周")) }
        if day != 0 { parts.append(String(localized: "\(abs(day))天")) }
        if hour != 0 { parts.append(String(localized: "\(abs(hour))小时")) }
        if minute != 0 { parts.append(String(localized: "\(abs(minute))分钟")) }
        if second != 0 { parts.append(String(localized: "\(abs(second))秒")) }
        if parts.isEmpty {
            return String(localized: "0 秒")
        }

        let joinedParts = parts.joined(separator: " ")
        return "\(joinedParts)"
    }

    public var text: String {
        if isMax {
            return String(localized: "结束时间")
        }
        // 如果全为 0， 开始时间
        if day == 0 && hour == 0 && year == 0 && month == 0 && week == 0 && minute == 0 && second == 0 {
            return String(localized: "开始时间")
        }
        return localizedDescription
    }
}
