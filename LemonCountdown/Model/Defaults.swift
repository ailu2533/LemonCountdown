//
//  Defaults.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let todayIsExpanded = Key<Bool>("todayIsExpanded", default: true)
    static let futureIsExpanded = Key<Bool>("futureIsExpanded", default: true)
    static let pastIsExpanded = Key<Bool>("pastIsExpanded", default: true)

    static let shouldShowOnboarding = Key<Bool>("shouldShowOnboarding", default: true)

    static let selectedTagUUID = Key<UUID?>("selectedTagUUID", default: nil)
}
