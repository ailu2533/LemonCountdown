//
//  WidgetPhaseEditorViewModel.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import Foundation
import LemonCountdownModel
import SwiftData
import SwiftMovable
import WidgetKit

@Observable
class WidgetPhaseEditorViewModel {
    // MARK: - 属性

    var selection: MovableObject?
//    var selectedMovableObjectUUID: UUID?
    var selectedImage = ""
    var selectedControl: Control = .background
    var selectedBackgroundKind = BackgroundKind.linearGredient
    var selectedFontName: String?
    var fontSize: CGFloat = 20
    var selectedSticker: String = stickerMap.keys.elements.first ?? ""
    var highlightX = false
    var highlightY = false
    var shouldShowGuideline = true
    var showInputText = false
    var text = ""
    var canDeleted = false

    private(set) var widgetTemplate: WidgetTemplate!
    private(set) var phase: WidgetPhase!
    private(set) var modelContext: ModelContext!
    private(set) var widgetCenter: CGPoint!

    // MARK: - 初始化方法

    func configure(widgetTemplate: WidgetTemplate, phase: WidgetPhase, modelContext: ModelContext, widgetCenter: CGPoint) {
        self.widgetTemplate = widgetTemplate
        self.phase = phase
        self.modelContext = modelContext
        self.widgetCenter = widgetCenter
        canDeleted = widgetTemplate.checkCanBeDeleted(phase: phase)
    }

    func addTextItem() {
        let textItem = TextItem(text: text, pos: widgetCenter)
        
        phase.texts.append(textItem)
        selection = textItem
        text = ""
    }

    // Saves the model when the view disappears or the scene phase changes.
    func saveWidgetTemplateModel() {
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
//            Logging.openUrl.debug("saveWidgetTemplateModel: \(model.title) \(model.uuid) template: \(widgetTemplate.hashValue)")

            // TODO: 优化
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    // Adds a sticker to the phase when selected.
    func addSticker(_ iconName: String) {
        let image = MovableSticker(stickerName: iconName, pos: widgetCenter)
        phase.stickers.append(image)
        selection = image
    }

    func addEventInfo(_ eventInfo: EventInfoKind) {
        let (fontName, fontSize) = getFontSettings(for: eventInfo)
        let mf = EventInfo(eventInfo: eventInfo, eventInfoProvider: phase.getEventInfoProvider(), position: widgetCenter, fontName: fontName, fontSize: fontSize)
        phase.eventInfo.append(mf)
        selection = mf
    }

    // Handles the change in selected control and creates a new text item if needed.
    func handleTextSelectionChange(oldValue: Control, newValue: Control) {
        if oldValue != .text && newValue == .text && selection as? TextItem == nil {
            createAndSelectNewTextItem()
        }
    }

    // Updates the selection details based on the selected object.
    func updateSelectionDetails(_ newValue: MovableObject?) {
        guard let newValue = newValue else { return }
        selectedControl = switch newValue {
        case is TextItem: .text
        case is MovableSticker: .sticker
        default: selectedControl
        }
    }

    // Creates and selects a new text item when needed.
    func createAndSelectNewTextItem() {
        let textItem = TextItem(text: String(localized: "双击编辑文案"), pos: widgetCenter)
        phase.texts.append(textItem)
        selection = textItem
    }

    // MARK: - 私有方法

    private func getFontSettings(for eventInfo: EventInfoKind) -> (String?, CGFloat) {
        let defaultFontName = "ChillRoundFRegular"
        let defaultFontSize: CGFloat = 20

        switch eventInfo {
        case .eventTitle:
            return (defaultFontName, 25)
        case .currentWeekDay:
            return (defaultFontName, 20)
        default:
            return (defaultFontName, defaultFontSize)
        }
    }
}
