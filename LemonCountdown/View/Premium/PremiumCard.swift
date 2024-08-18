//
//  PremiumCard.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/31.
//

import RevenueCatUI
import SwiftUI

struct PremiumCard: View {
    @State private var showPaywallSheet = false
    @State private var showPremiumSheet = false

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(hex: "#85FFBD")!)
            .shadow(radius: 1.5)
            .frame(minWidth: 250, idealWidth: 300, maxWidth: 320, idealHeight: 150)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color(hex: "#FFF500")!, Color(hex: "#FFFACD")!, Color(hex: "#FFF8DC")!], startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 1)
                    .overlay(content: {
                        VStack {
                            Image(.guarantee9123345)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .grayscale(0)
                                .shadow(color: .white, radius: 6)
                            if MembershipManager.shared.isPremiumUser {
                                Text(MembershipManager.shared.membershipType)
                            } else {
                                Text("开通会员")
                            }
                        }
                    })

                    .padding(8)
            }
            .padding()
            .onTapGesture {
                if MembershipManager.shared.isPremiumUser {
                    showPremiumSheet = true
                } else {
                    showPaywallSheet = true
                }
            }

            .task {
                MembershipManager.shared.checkMembershipStatus()
            }
            .sheet(isPresented: $showPaywallSheet, content: {
                PaywallView(displayCloseButton: true)
                    .onRestoreCompleted { info in
                        MembershipManager.shared.checkMembershipStatus()
                        Logging.shared.debug("onRestoreCompleted \(info.entitlements.debugDescription)")
                    }

                    .onRestoreFailure { error in
                        Logging.shared.error("onRestoreFailure: \(error.localizedDescription)")
                    }
                    .onPurchaseCompleted { _ in
                        MembershipManager.shared.checkMembershipStatus()
                    }
            })

            .sheet(isPresented: $showPremiumSheet, content: {
                PremiumRight()
            })
    }
}

#Preview {
    PremiumCard()
}
