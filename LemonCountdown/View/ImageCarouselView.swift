//
//  ImageCarouselView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

struct LazyImageView: View {
    private let name: String
    private var width: Int

    init(imageName: String, width: Int = 300) {
        name = imageName
        self.width = width
    }

    var body: some View {
//        Image.thumbnailImageFixWidth(name, width: width)
        Text("TODO")
    }
}

// 图片轮播视图
public struct ImageCarouselView: View {
    private var imageNames: [String]

    @Binding private var selectedImage: String

    init(imageNames: [String], selectedImage: Binding<String>) {
        self.imageNames = imageNames
        _selectedImage = selectedImage
    }

    public var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(imageNames, id: \.self) { img in
                        LazyImageView(imageName: img, width: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding()
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1.0)
                                    .opacity(selectedImage == img ? 1 : 0)
                            })

                            .onTapGesture {
                                selectedImage = img
                            }
                    }
                }.sensoryFeedback(.selection, trigger: selectedImage)
            }
        }
    }
}
