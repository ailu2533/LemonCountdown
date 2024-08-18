////
////  ImageThumbnailView.swift
////  LemonEvent
////
////  Created by ailu on 2024/4/21.
////
//
// import LemonUtils
// import PopupView
// import SwiftUI
//
// @Observable
// class TextViewModel {
//    var textItems: [TextItem] = []
//
//    func addItem(_ item: TextItem) {
//        textItems.append(item)
//    }
//
//    func removeItem(_ item: TextItem) {
//        textItems.removeAll {
//            $0.id == item.id
//        }
//    }
// }
//
// struct ImageThumbnailView: View {
//    @State private var selectedBackgroundImg = "bg1"
//
//    @State private var vm = TextViewModel()
//
//    @State private var selectedText: TextItem?
//
//    @State private var bgCenter: CGSize = .zero
//
//    @State private var showBgSheet = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Color.red.opacity(0.2).onTapGesture {
//                    selectedText = nil
//                }.frame(height: 400)
//                    .overlay {
//                        LazyImageView(imageName: selectedBackgroundImg)
//
//                            .allowsHitTesting(false)
//                            .overlay {
//                                GeometryReader { proxy in
//
//                                    Color.clear.onAppear {
//                                        self.bgCenter = .init(width: proxy.size.width / 2, height: proxy.size.height / 2)
//                                    }
//
//                                    ForEach(vm.textItems) { item in
//                                        MovableObjectView(textItem: item, selected: selectedText?.id == item.id) { item in
//                                            Text(item.text)
//                                        }
//
//                                        .onTapGesture {
//                                            selectedText = item
//                                        }
//                                    }
//                                }
//                            }
//                    }
//
//                Spacer()
//
//                HStack {
//                    Group {
//                        Button(action: {
//                            showBgSheet.toggle()
//                        }, label: {
//                            Text("Background")
//                        })
//
//                        Button(action: {
//                            vm.addItem(.init(text: "hello", pos: .init(x: self.bgCenter.width, y: self.bgCenter.height)))
//                        }, label: {
//                            Text("Add Text")
//                        })
//
//                    }.buttonStyle(BigButtonStyle())
//                }
//            }
//        }
//
//        .popup(isPresented: $showBgSheet) {
//            ImageCarouselView(imageNames: commonBackgroundImgs, selectedImage: $selectedBackgroundImg)
//                .background(Color(.systemBackground))
//
//        } customize: {
//            $0.type(.scroll(headerView: AnyView(EmptyView())))
//                .position(.bottom)
//                .closeOnTapOutside(true)
//        }
//
//        .environment(vm)
//    }
// }
//
// #Preview {
//    ImageThumbnailView()
// }
