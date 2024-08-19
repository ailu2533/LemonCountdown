//
//  CatWidget.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/5.
//

import Combine
import HorizontalPicker
import LemonCountdownModel
import LemonUtils
import PagerTabStripView
import SwiftData
import SwiftMovable
import SwiftUI
import WidgetKit

// Enum representing different controls for editing the widget.
enum Control: Int, Hashable {
//    case none
    case sticker
    case text
    case background
    case eventInfo

    var text: LocalizedStringKey {
        switch self {
        case .sticker:
            "贴纸"
        case .text:
            "文字"
        case .eventInfo:
            "事件信息"
        case .background:
            "背景"
        }
    }
}

// Enum representing different text actions.
enum TextAction: LocalizedStringKey {
    case edit
    case add
}

// Represents a phase of the widget editing process.
struct WidgetPhaseEditorView: View {
    @Environment(WidgetTemplate.self)
    private var widgetTemplate

    // Represents a phase of the widget editing process.
    @Bindable var phase: WidgetPhase

    // Size of the widget being edited.
    let widgetSize: CGSize
    // Center point of the widget for positioning elements.
    let widgetCenter: CGPoint
    // Fixed height for the bottom panel.
    let height = 264.0

//    let phaseID: UUID

    // Template of the widget which includes multiple phases.
//    let widgetTemplate: WidgetTemplate
    // Flag to disable the delete operation if only one phase exists.
    @State private var canDeleted = false

    init(phase: WidgetPhase, widgetSize: CGSize) {
        self.widgetSize = widgetSize
        widgetCenter = .init(x: widgetSize.width / 2, y: widgetSize.height / 2)

        Logging.openUrl.debug("WidgetPhaseEditorView init ")

        self.phase = phase
    }

    // State variables for managing UI interactions and selections.
    @State private var selected: MovableObject?
    @State private var selectedImage = ""
    @State private var selectedControl: Control = .background
    @State private var selectedColorSet = "纯色"
    @State private var text = ""
    @State private var showInputText = false

//    @State private var textAction = TextAction.add

    @State private var selectedBackgroundKind = BackgroundKind.linearGredient

    @State private var selectedFontName: String?
    @State private var fontSize: CGFloat = 20

    // Environment variables for managing app state and interactions.
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(ViewModel.self) private var vm

    @State private var selectedSticker: String = stickerMap.keys.elements.first ?? ""

    @State private var selectedTextKind = "字体"

    @State private var highlightX = false
    @State private var highlightY = false

    @State private var shouldShowGuildline = true

    var draggingState = DraggingState()

    // View for displaying the main card of the widget.
    var card: some View {
        ZStack {
            Color(.systemBackground)
                .onTapGesture {
                    selected = nil
                }
            WidgetCardView2(model: phase, widgetSize: widgetSize, selected: $selected)

                .overlayPreferenceValue(ViewSizeKey.self) { preferences in
                    GeometryReader { geometry in
                        preferences.map {
                            Color.clear
                                .onChange(of: geometry[$0]) { _, newValue in
                                    highlightX = (abs(newValue.x - widgetSize.width / 2) <= 3)
                                    highlightY = (abs(newValue.y - widgetSize.height / 2) <= 3)
                                }
                        }
                    }
                }
                .sensoryFeedback(.impact(flexibility: .rigid, intensity: 0.5), trigger: highlightX, condition: { oldValue, newValue in
                    !oldValue && newValue && selected != nil
                })
                .sensoryFeedback(.impact(flexibility: .rigid, intensity: 0.5), trigger: highlightY, condition: { oldValue, newValue in
                    !oldValue && newValue && selected != nil
                })

                .overlay(content: {
                    Line().stroke(lineWidth: 1.0).frame(width: widgetSize.width, height: 1)
                        .foregroundStyle(Color.chineseRed)
                        .opacity(highlightY && draggingState.isDragging ? 1 : 0)

                    Line().stroke(lineWidth: 1.0).frame(width: widgetSize.height, height: 1)
                        .foregroundStyle(Color.chineseRed)
                        .rotationEffect(.degrees(90))
                        .opacity(highlightX && draggingState.isDragging ? 1 : 0)
                })
        }
    }

    // Control panel for selecting different editing options based on the selected control.
    @ViewBuilder
    var controlPanel: some View {
        ControlPanel(selectedControl: $selectedControl, selectedSticker: $selectedSticker, showInputText: $showInputText, selectedBackgroundKind: $selectedBackgroundKind)
            .contentMargins(.horizontal, 12)
            .frame(maxHeight: 30)
            .padding(.vertical, 10)
    }

    // Bottom panel with tabs for different editing controls.
    var bottomPanel: some View {
        PagerTabStripView(swipeGestureEnabled: .constant(false), selection: $selectedControl) {
            @Bindable var phase = phase

            BackgroundPickerView(selectedBackgroundKind: selectedBackgroundKind, background: phase.background)
                .pagerTabItem(tag: Control.background) {
                    TabItemView(title: Control.background.text)
                }

            SingleIconSetIconPickerView(selectedImg: $selectedImage, icons: stickerMap[selectedSticker] ?? [], tapCallback: addSticker)
                .pagerTabItem(tag: Control.sticker) {
                    TabItemView(title: Control.sticker.text)
                }

            TextStyleEditor(textItem: Binding(
                get: { selected as? Stylable },
                set: { newValue in
                    if var selected = selected as? Stylable {
                        if let colorHex = newValue?.colorHex {
                            selected.colorHex = colorHex
                        }

                        selected.fontName = newValue?.fontName

                        if let fontSize = newValue?.fontSize {
                            selected.fontSize = fontSize
                        }
                    }
                }), selectedFontName: $selectedFontName, fontSize: $fontSize)
                .pagerTabItem(tag: Control.text) {
                    TabItemView(title: Control.text.text)
                }
            EventInfoPickerView(tapCallback: addEventInfo, wigetPhaseTimeKind: phase.kind)
                .pagerTabItem(tag: Control.eventInfo) {
                    TabItemView(title: Control.eventInfo.text)
                }
        }
        .contentMargins(.vertical, 30, for: .scrollContent)
        .pagerTabStripViewStyle(BarButtonStyle(tabItemHeight: 36,
                                               indicatorView: {
                                                   AnyView(Rectangle().fill(Color.accentColor).frame(height: 2))
                                               }))

        .background(Color(.systemGray6))
        .frame(height: height)
    }

    // Main body of the view, organizing the layout of the card, control panel, and bottom panel.
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                VStack {
                    Spacer()

                    card // Displays the main card of the widget.
                    Spacer()

                    VStack(spacing: 0) {
                        controlPanel // Displays the control panel for editing options.

                        bottomPanel
                    }
                }
            }.toolbar {
                if canDeleted {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .destructive) {
                            Logging.openUrl.debug("widgetTemplate: \(widgetTemplate.id)")
                            widgetTemplate.deleteWidgetPhase(phase)
                            dismiss()
                        } label: {
                            Label {
                                Text("删除")
                            } icon: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveWidgetTemplateModel()
                        dismiss()
                    } label: {
                        Label {
                            Text("保存")
                        } icon: {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
        }

        .environment(draggingState)
        .ignoresSafeArea(.all, edges: .bottom)
        .onDisappear {
            saveWidgetTemplateModel()
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if oldValue == .active && newValue == .inactive {
                saveWidgetTemplateModel()
            }
        })

        .alert("输入文字", isPresented: $showInputText) {
            TextField("", text: $text)
            Button("Cancel", role: .cancel) { }
            Button(action: {
                let textItem = TextItem(text: text, pos: widgetCenter)
                phase.texts.append(textItem)

                selected = textItem

                text = ""
            }, label: {
                Text("OK")
            })
        }

//        .animation(.easeIn, value: selectedControl) // Adds an ease-in animation based on the selected control.
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .inactive {
                saveWidgetTemplateModel() // Saves the model when the scene becomes inactive.
            }
        }
        .onChange(of: selected) { _, newValue in
            updateSelectionDetails(newValue) // Updates selection details when a new object is selected.
        }
        .onAppear {
            canDeleted = widgetTemplate.checkCanBeDeleted(phase: phase)
        }
    }

    // Saves the model when the view disappears or the scene phase changes.
    fileprivate func saveWidgetTemplateModel() {
        Logging.openUrl.debug("saveWidgetTemplateModel: TODO")

        if let model = widgetTemplate.getWidgetTemplateModel() {
            if model.modelContext == nil {
                print("insert Model")
                modelContext.insert(model)
            }

            if model.isDeleted {
                return
            }

            model.jsonData = WidgetTemplateModel.encodeWidgetTemplate(widgetTemplate)
            Logging.openUrl.debug("jsonData: \(model.jsonData)")
            Logging.openUrl.debug("saveWidgetTemplateModel: \(model.title) \(model.uuid) template: \(widgetTemplate.hashValue)")

            // TODO: 优化
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    // Adds a sticker to the phase when selected.
    fileprivate func addSticker(_ iconName: String) {
        let image = MovableSticker(stickerName: iconName, pos: widgetCenter)
        phase.stickers.append(image)
        selected = image
    }

    func addEventInfo(_ eventInfo: EventInfoKind) {
        // 根据用户的地区和 meta info type 决定fontName
        // widgetSize 决定fontSize

        // ChillRoundFRegular
        var fontName: String? = "ChillRoundFRegular"
        var fontSize: CGFloat = 20

        if eventInfo == .eventTitle {
            fontSize = 25
        } else if eventInfo == .currentWeekDay {
            fontSize = 20
        } else {
            fontName = "ChillRoundFRegular"
        }

        let mf = EventInfo(eventInfo: eventInfo, eventInfoProvider: phase.getEventInfoProvider(), position: widgetCenter, fontName: fontName, fontSize: fontSize)
        phase.eventInfo.append(mf)
        selected = mf
    }

    // Handles the change in selected control and creates a new text item if needed.
    fileprivate func handleTextSelectionChange(oldValue: Control, newValue: Control) {
        if oldValue != .text && newValue == .text && selected as? TextItem == nil {
            createAndSelectNewTextItem()
        }
    }

    // Updates the selection details based on the selected object.
    fileprivate func updateSelectionDetails(_ newValue: MovableObject?) {
        if let newValue {
            switch newValue {
            case is TextItem:
//                textAction = .edit
                selectedControl = .text
            case is MovableSticker:
                selectedControl = .sticker
            default:
                break
            }
        }
    }

    // Creates and selects a new text item when needed.
    fileprivate func createAndSelectNewTextItem() {
        let textItem = TextItem(text: String(localized: "双击编辑文案"), pos: widgetCenter)
        phase.texts.append(textItem)
        selected = textItem
//        textAction = .edit
    }
}

// View for selecting a background color or gradient for the phase.
struct BackgroundPickerView: View {
    var selectedBackgroundKind: BackgroundKind
    @Bindable var background: Background

    var body: some View {
        switch selectedBackgroundKind {
        case .morandiColors:
            ColorPickerView2(selection: Binding(get: {
                background.backgroundColor ?? ""
            }, set: { newColor in
                background.kind = .morandiColors
                background.backgroundColor = newColor
                Logging.bg.debug("new color: \(newColor)")
            }), colorSet: ColorSets.morandiColors)
        case .macaronColors:
            ColorPickerView2(selection: Binding(get: {
                background.backgroundColor ?? ""
            }, set: { newColor in
                background.kind = .macaronColors
                background.backgroundColor = newColor
            }), colorSet: ColorSets.macaronColors)
        case .linearGredient:
            LinearGradientPicker(selection: Binding(get: {
                background.linearGradient ?? []
            }, set: { newColor in
                background.kind = .linearGredient
                background.linearGradient = newColor
            }))
        }
    }
}

struct TabItemView: View {
    var title: LocalizedStringKey

    init(title: LocalizedStringKey) {
        self.title = title
    }

    var body: some View {
        Text(title)
    }
}
