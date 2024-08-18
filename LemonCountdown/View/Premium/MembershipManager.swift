//
//  MembershipManager.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/31.
//

import Foundation
import RevenueCat

@Observable
class MembershipManager {
    static let shared = MembershipManager()

    var isPremiumUser = false
    var membershipType = "None"

    private init() {
//        checkMembershipStatus()
    }

    func checkMembershipStatus() {
//        Purchases.shared.getCustomerInfo { customerInfo, error in
//            if let error = error {
//                print("Failed to get customer info: \(error.localizedDescription)")
//                self.isPremiumUser = false
//                self.membershipType = "None"
//            } else if let customerInfo = customerInfo {
//                Logging.membershipManager.debug("checkMembershipStatus: \(customerInfo.debugDescription)")
//                // Replace "premium" with your actual entitlement identifier
//                if let entitlement = customerInfo.entitlements["premium"], entitlement.isActive {
//                    self.isPremiumUser = true
//                    self.membershipType = self.getMembershipType(from: entitlement)
//                } else {
//                    self.isPremiumUser = false
//                    self.membershipType = "None"
//                }
//            }
//        }
    }

    private func getMembershipType(from entitlement: EntitlementInfo) -> String {
        let productIdentifier = entitlement.productIdentifier
        switch productIdentifier {
        case "lemon_widget_lifetime4":
            return "Lifetime"
        case "lemon_widget_yearly":
            return "Annual"
        case "lemon_widget_monthly":
            return "Monthly"
        default:
            return "Unknown"
        }
    }
}
