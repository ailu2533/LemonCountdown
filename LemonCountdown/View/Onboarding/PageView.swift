//
//  PageView.swift
//  LemonCountdown
//
//  Created by ailu on 2024/5/19.
//

import Foundation
import SwiftUI

struct PageView: View {
    @Binding var showOnborading: Bool

    let page: PageData
    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350

    var body: some View {
        return VStack(alignment: .center, spacing: 20) {
            Text(page.title)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(page.textColor)
                .frame(width: textWidth)
                .multilineTextAlignment(.center)
            if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
//                    .aspectRatio(aspect, contentMode: .fit)
                    .cornerRadius(25)
                    .clipped()
                    .padding()
            }

            VStack(alignment: .center, spacing: 5) {
                Text(page.header)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
                Text(page.content)
                    .font(Font.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
