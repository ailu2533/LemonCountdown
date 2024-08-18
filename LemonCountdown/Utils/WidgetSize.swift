//
//  WidgetSize.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation
import UIKit

enum WidgetSize: Int, CaseIterable, Identifiable, Codable {
    case small = 0
    case medium = 1
    case large = 2

    var text: String {
        switch self {
        case .small:
            return String(localized: "small widget")
        case .medium:
            return String(localized: "medium widget")
        case .large:
            return String(localized: "large widget")
        }
    }

    var id: Int {
        return rawValue
    }
}

struct ScreenSize: Hashable, Equatable {
    var width: CGFloat
    var height: CGFloat

    func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }

    static func == (lhs: ScreenSize, rhs: ScreenSize) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

struct SizeHelper {
    private static let smallMap = buildSmallWidgetSize()
    private static let mediumMap = buildMediumWidgetSize()
    private static let largeMap = buildLargeWidgetSize()

    static func getSmall() -> CGSize {
        let s = UIScreen.main.bounds
        return smallMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 148, height: 148)
    }

    static func getMedium() -> CGSize {
        let s = UIScreen.main.bounds
        return mediumMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 321, height: 148)
    }

    static func getLarge() -> CGSize {
        let s = UIScreen.main.bounds
        return largeMap[.init(width: s.width, height: s.height)] ?? CGSize(width: 321, height: 337)
    }

    static func getSize(_ ws: WidgetSize) -> CGSize {
        switch ws {
        case .small:
            getSmall()
        case .medium:
            getMedium()
        case .large:
            getLarge()
        }
    }

    // 根据 iphone 的 resolution 决定 widget 的 size
    static func buildSmallWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 170, height: 170)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 158, height: 158)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 170, height: 170)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 158, height: 158)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 155, height: 155)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 148, height: 148)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 155, height: 155)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 169, height: 169)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 169, height: 169)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 159, height: 159)

        return mp
    }

    static func buildMediumWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 364, height: 170)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 338, height: 158)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 364, height: 170)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 338, height: 158)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 155)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 321, height: 148)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 155)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 169)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 169)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 348, height: 159)

        return mp
    }

    static func buildLargeWidgetSize() -> [ScreenSize: CGSize] {
        var mp = [ScreenSize: CGSize]()

        // width is logical width, height is logical height
        // iPhone 15 Pro Max, iPhone 15 Plus, iPhone 14 Pro Max
        mp[.init(width: 430, height: 932)] = .init(width: 364, height: 380)
        // iPhone 15 Pro, iPhone 15, iPhone 14 Pro, iPhone 14
        mp[.init(width: 393, height: 852)] = .init(width: 338, height: 354)
        // iPhone 14 Plus, iPhone 13 Pro Max
        mp[.init(width: 428, height: 926)] = .init(width: 364, height: 380)
        // iPhone 13, iPhone 13 Pro, iPhone 12, iPhone 12 Pro
        mp[.init(width: 390, height: 844)] = .init(width: 338, height: 354)
        // iPhone 13 mini, iPhone 12 mini
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 345)
        // iPhone SE 3rd gen, iPhone SE 2nd gen, iPhone 8, iPhone 7
        mp[.init(width: 375, height: 667)] = .init(width: 321, height: 337)
        // iPhone 11 Pro, iPhone XS, iPhone X
        mp[.init(width: 375, height: 812)] = .init(width: 329, height: 345)
        // iPhone 11, iPhone XR
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 376)
        // iPhone 11 Pro Max, iPhone XS Max
        mp[.init(width: 414, height: 896)] = .init(width: 360, height: 376)
        // iPhone 8 Plus, iPhone 7 Plus
        mp[.init(width: 414, height: 736)] = .init(width: 348, height: 364)

        return mp
    }
}
