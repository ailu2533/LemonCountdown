//
//  TextEditView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/22.
//

import LemonUtils
import SwiftUI

struct ImageHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public struct ThreePanelCardView2<Header: View, Content: View, Footer: View>: View {
    var header: () -> Header
    var content: () -> Content
    var footer: () -> Footer

    var headerHeight: CGFloat = 50
    var contentHeight: CGFloat = 0
    var footerHeight: CGFloat = 50

    public init(header: @escaping () -> Header, content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.header = header
        self.content = content
        self.footer = footer
    }

    public var body: some View {
        let shape = ThreePanelCardShape(radius: 8, first: headerHeight, second: contentHeight)

        ZStack {
            shape
                .fill(.background)
                .frame(width: 300)
                .frame(height: headerHeight + contentHeight + footerHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .shadow(radius: 8)
//                .blur(radius: 1)

            VStack(spacing: 0) {
                header()

                content()

                footer()
            }
            .frame(width: 300)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .mask {
                shape
            }
        }.onAppear(perform: {
            print("\(headerHeight) \(contentHeight) \(footerHeight)")
        })

        .overlay(alignment: .top, content: {
            Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [3])).frame(width: 285, height: 1)
                .foregroundStyle(Color(.black))
                .offset(y: headerHeight + contentHeight)
        })
    }
}

struct TestView: View {
    var body: some View {
        ThreePanelCardView {
            Text("生日")
                .frame(height: 50)
        } content: {
            Text("还有3天")
                .font(.title)
                .fontWeight(.heavy)
                .frame(height: 205)
        } footer: {
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(height: 50)
        }
    }
}

@MainActor
struct ScreenShootView: View {
    @State private var img: UIImage?
    @Environment(\.displayScale) var displayScale

    @State private var renderedImage: Image?

    var card: some View {
        ThreePanelCardView {
            Text("生日")
                .frame(height: 50)
        } content: {
            Text("还有3天")
                .font(.title)
                .fontWeight(.heavy)
                .frame(height: 205)
        } footer: {
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(height: 50)
        }
    }

    var body: some View {
        VStack {
            card
            Spacer()
            VStack {
                Button(action: {
                    let renderer = ImageRenderer(content: card)
                    renderer.scale = displayScale
                    if let image = renderer.uiImage {
                        renderedImage = Image(uiImage: image)
                    }
                }, label: {
                    Text("Render")
                })

                if let renderedImage {
                    renderedImage
                }
            }
        }
    }
}

#Preview {
    ScreenShootView()
}
