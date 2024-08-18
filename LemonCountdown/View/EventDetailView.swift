////
////  EventDetailView.swift
////  LemonEvent
////
////  Created by ailu on 2024/4/18.
////
//
// import LemonUtils
// import SwiftUI
//
// public struct ContentHeightPreferenceKey: PreferenceKey {
//    public static let defaultValue: CGFloat = 0
//
//    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//    }
// }
//
// public struct CardSizePreferenceKey: PreferenceKey {
//    public static let defaultValue: CGSize = .zero
//
//    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//    }
// }
//
// extension View {
//    public func readCardSize(perform: @escaping (CGSize) -> Void) -> some View {
//        background {
//            GeometryReader(content: { proxy in
//                Color.clear.preference(key: CardSizePreferenceKey.self, value: proxy.size)
//            })
//        }
//        .onPreferenceChange(CardSizePreferenceKey.self, perform: perform)
//    }
//
//    public func readContentHeight(perform: @escaping (CGFloat) -> Void) -> some View {
//        background {
//            GeometryReader(content: { proxy in
//                Color.clear.preference(key: ContentHeightPreferenceKey.self, value: proxy.size.height)
//            })
//        }
//        .onPreferenceChange(ContentHeightPreferenceKey.self, perform: perform)
//    }
// }
//
// @Observable
// class CardViewModel {
//    var textItems: [TextItem] = []
//
//    let headerHeight: CGFloat = 0
//    var contentHeight: CGFloat = 0
//    let footerHeight: CGFloat = 50
//
//    var cardSize = CGSize.zero
//
//    var selectedBackgroundImg: String = "bg1"
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
// struct EventDetailView: View {
//    let defaultBg = commonBackgroundImgs.first!
//
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.displayScale) private var displayScale
//
//    @Environment(ViewModel.self) private var vm
//    @Bindable private var eventModel: EventModel
//
//    @State private var cvm = CardViewModel()
//
//    @State private var selectedText: TextItem?
//
//    @State private var showSheet = false
//    @State private var showSharesheet = false
//
//    @State private var showBackgroundPicker = false
//    @State private var selectedBackground = ""
//
//    private var backgroundImages = commonBackgroundImgs
//
//    @State private var cardSize = CGSize.zero
//
//    @State private var items: [Any] = []
//
//    init(eventModel: EventModel) {
//        self.eventModel = eventModel
//    }
//
//    func edit(item: TextItem) {
//        vm.eventNavigationPath.append(item)
//    }
//
//    var backgroundView: some View {
//        let color = Color(hex: eventModel.colorHex)!
//
//        return RoundedRectangle(cornerRadius: 8)
//            .fill(LinearGradient(colors:
//                [color.opacity(0.2), Color.cyan.opacity(0.1)],
//                startPoint: .top, endPoint: .bottom))
//            .ignoresSafeArea()
//    }
//
//    func card(preview: Bool = false) -> some View {
//        let title = eventModel.title
//        let date = eventModel.nextStartDate
//
//        return ThreePanelInternalCardView(headerHeight: cvm.headerHeight, contentHeight: cvm.contentHeight, footerHeight: cvm.footerHeight) {
//            Color.clear
//                .frame(height: 0)
//        } content: {
//            LazyImageView(imageName: eventModel.backgroundImage ?? defaultBg)
//                .onTapGesture {
//                    selectedText = nil
//                }
//                .overlay {
//                    GeometryReader { _ in
//                        ForEach(cvm.textItems) { item in
//
//                            let selected = !preview && selectedText?.id == item.id
//
//                            MovableObjectView(textItem: item, selected: selected) { item1 in
//                                cvm.removeItem(item1)
//                            } editCallback: { item1 in
//                                edit(item: item1)
//                            } content: { item1 in
//                                item1.view()
//                            }
//                            .onTapGesture {
//                                selectedText = item
//                            }
//                        }
//                    }
//                }.readContentHeight { cvm.contentHeight = $0 }
//        } footer: {
//            Text(date.formatted(date: .abbreviated, time: .omitted))
//                .font(.caption)
//                .foregroundStyle(.secondary)
//                .frame(height: 50)
//        }
//    }
//
//    @MainActor
//    var bottomButtonGroup: some View {
//        return HStack {
//            Group {
//                Button(action: {
//                    let renderer = ImageRenderer(content: card(preview: true).frame(width: cardSize.width, height: cardSize.height))
//                    renderer.scale = displayScale
//                    if let img = renderer.uiImage {
//                        items = [ItemDetailSource(name: eventModel.title, image: img)]
//
//                        showSharesheet = true
//                    }
//
//                }, label: {
//                    Text("导出")
//                })
//
//                Button(action: {
//                    cvm.addItem(.init(text: "点击后编辑", pos: .init(x: 150, y: 75)))
//                }, label: {
//                    Text("新增文字")
//                })
//
//                Button(action: {
//                    showBackgroundPicker.toggle()
//                }, label: {
//                    Text("样式编辑")
//                })
//                Button(action: {
//                    dismiss()
//                }, label: {
//                    Text("关闭")
//                })
//
//            }.buttonStyle(BigButtonStyle())
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            backgroundView
//            VStack {
//                card().readCardSize { cardSize = $0 }
//
//                bottomButtonGroup
//            }
//        }
//        .popup(isPresented: $showBackgroundPicker) {
//            ImageCarouselView(imageNames: commonBackgroundImgs, selectedImage: $selectedBackground)
//                .background(Color(.systemBackground))
//                .onChange(of: selectedBackground) { _, newValue in
//                    eventModel.backgroundImage = newValue
//                }
//
//        } customize: {
//            $0.type(.scroll(headerView: AnyView(EmptyView())))
//                .position(.bottom)
//                .closeOnTapOutside(true)
//        }
//
//        .toolbar(content: {
//            Menu {
//                Button(action: {
//                    showSheet = true
//                }, label: {
//                    Text("编辑")
//                })
//                Button(role: .destructive, action: {
//                    vm.delete(model: eventModel)
//                    dismiss()
//                }, label: {
//                    Text("删除")
//                })
//            } label: {
//                Label("选项", systemImage: "ellipsis.circle")
//            }
//
//        })
//        .sheet(isPresented: $showSheet, content: {
//            EventEditorView(event: eventModel)
//        })
//        .sheet(isPresented: $showSharesheet, content: {
//            Sharesheet(items: items)
//        })
//
//        .onAppear {
//            if let backgroundImg = eventModel.backgroundImage {
//                selectedBackground = backgroundImg
//            }
//        }
//    }
// }
