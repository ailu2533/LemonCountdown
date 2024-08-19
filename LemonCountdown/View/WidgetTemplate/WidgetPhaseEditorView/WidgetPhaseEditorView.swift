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
    @State private var selectedBackgroundKind = BackgroundKind.linearGredient

    @State private var selectedFontName: String?
    @State private var fontSize: CGFloat = 20

    // Environment variables for managing app state and interactions.
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(ViewModel.self) private var vm

    @State private var selectedSticker: String = stickerMap.keys.elements.first ?? ""

    @State private var highlightX = false
    @State private var highlightY = false

    @State private var shouldShowGuildline = true

    @State private var showInputText = false

    @State private var text = ""
    @State private var canDeleted = false

    var draggingState = DraggingState()

    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                VStack {
                    Spacer()
                    WidgetCardView3(phase: phase, widgetSize: widgetSize, selected: $selected, highlightX: $highlightX, highlightY: $highlightY, draggingState: draggingState)
                    Spacer()
                    WidgetEditorControlsView(selectedControl: $selectedControl, selectedSticker: $selectedSticker, showInputText: $showInputText, selectedBackgroundKind: $selectedBackgroundKind, phase: phase, selected: $selected, selectedImage: $selectedImage, selectedFontName: $selectedFontName, fontSize: $fontSize, addSticker: addSticker, addEventInfo: addEventInfo, height: height)
                }
            }
            .toolbar {
                WidgetEditorToolbarContent(canDeleted: canDeleted, widgetTemplate: widgetTemplate, phase: phase, dismiss: dismiss, saveAction: saveWidgetTemplateModel)
            }
        }
        .environment(draggingState)
        .ignoresSafeArea(.all, edges: .bottom)
        .onDisappear(perform: saveWidgetTemplateModel)
        .onChange(of: scenePhase) { oldValue, newValue in
            if oldValue == .active && newValue == .inactive {
                saveWidgetTemplateModel()
            }
        }
        .alert("输入文字", isPresented: $showInputText) {
            textInputAlert
        }
        .onChange(of: selected, perform: updateSelectionDetails)
        .onAppear {
            canDeleted = widgetTemplate.checkCanBeDeleted(phase: phase)
        }
    }

    private var textInputAlert: some View {
        Group {
            TextField("", text: $text)
            Button("取消", role: .cancel) { }
            Button("确定", action: addTextItem)
        }
    }

    private func addTextItem() {
        let textItem = TextItem(text: text, pos: widgetCenter)
        phase.texts.append(textItem)
        selected = textItem
        text = ""
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
        guard let newValue = newValue else { return }
        selectedControl = switch newValue {
        case is TextItem: .text
        case is MovableSticker: .sticker
        default: selectedControl
        }
    }

    // Creates and selects a new text item when needed.
    fileprivate func createAndSelectNewTextItem() {
        let textItem = TextItem(text: String(localized: "双击编辑文案"), pos: widgetCenter)
        phase.texts.append(textItem)
        selected = textItem
    }
}
