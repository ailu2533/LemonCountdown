//
//  NavigationUtils.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/21.
//

import Foundation
import SwiftUI

final class Navigation: ObservableObject {
    @Published var path = NavigationPath()
}

extension EnvironmentValues {
    private struct NavigationKey: EnvironmentKey {
        static let defaultValue = Navigation()
    }

    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}
