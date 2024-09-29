//
//  AddEventView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import EventKit
import HorizontalPicker
import LemonCountdownModel
//import LemonUtils
import Shift
import SwiftData
import SwiftUI
import SwiftUIX
import TipKit

// MARK: - EditEventView

struct EventEditorView: View {
    // MARK: - Environment Objects

    @Environment(ViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - State Variables

    @ObservationIgnored private var event: EventModel?
    @ObservationIgnored private var originEventModel: EventModel?
    @State private var cb = EventBuilder()
    @State private var showToast = false
    @State private var errorMsg = ""
    @State private var saveSuccess = false
    @State private var showDeleteConfirm = false
    @State private var showSheet = false

    let changeIconTip = ChangeIconTip()

    // MARK: - Initializer

    init(event: EventModel? = nil) {
        self.event = event
        if let event {
            let cb = EventBuilder()
            cb.postInit(event)
            originEventModel = cb.notificationConfigCopy()
        }
    }

    // MARK: - Private Methods

    // MARK: Icon View

    fileprivate func iconView() -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: cb.colorHex) ?? Color.clear)
                .frame(width: 70, height: 70)

            Image(cb.icon).resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
        .onTapGesture {
            showSheet = true
        }
    }

    // MARK: Save Event

    fileprivate func saveEvent() {
        if cb.title.isEmpty {
            errorMsg = "标题不能为空"
            showToast.toggle()
            return
        }

        if cb.endDate <= cb.startDate {
            errorMsg = "结束时间需要大于开始时间"
            showToast.toggle()
            return
        }

        if let event {
            event.updateFrom(builder: cb)
            event.invalidateCache()
            vm.modifyEvent(event)

            Task {
                if let originEventModel {
                    await CalendarUtils.modifyNotification(origin: originEventModel, modified: event, cb: cb)
                }
            }
        } else {
            do {
                let newEvent = try cb.build()
                vm.addEvent(newEvent)

                Task {
                    await CalendarUtils.addNotification(newEvent)
                }
            } catch {
                errorMsg = error.localizedDescription
                showToast = true
                return
            }
        }

        saveSuccess = true
        dismiss()
    }

    // MARK: Initialize Event

    fileprivate func initEvent() {
        if let event {
            cb.postInit(event)
        }

        if cb.colorHex.isEmpty {
            cb.colorHex = ColorSets.morandiColors.first!
        }

        if cb.icon.isEmpty {
            let key = iconsMap.keys.first!
            let value = iconsMap[key]?.first
            cb.icon = value!
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            mainContent
                .toolbar {
                    toolbarContent
                }
                .alert(errorMsg, isPresented: $showToast, actions: {
                    Button("好的", role: .cancel) { }
                })
                .confirmationDialog("确认删除", isPresented: $showDeleteConfirm, actions: {
                    deleteConfirmationButtons
                }, message: {
                    Text("事件被删除后，您将不会收到提醒")
                })
                .sheet(isPresented: $showSheet, content: {
                    IconPickerView(selectedIcon: $cb.icon, iconSets: iconsMap)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                })
                .onAppearOnce {
                    initEvent()
                }
        }
    }

    // MARK: Main Content View

    private var mainContent: some View {
        VStack(spacing: 0) {
            Form {
                formContent
            }
        }
        .background(Color(.systemGray6))
        .onChange(of: cb.startDate, { _, _ in
            if cb.isAllDayEvent {
                cb.adjustDate()
            }
        })
    }

    // MARK: Toolbar Content

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("取消") {
                dismiss()
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("保存") {
                saveEvent()
            }
        }
    }

    // MARK: Delete Confirmation Buttons

    @ViewBuilder
    private var deleteConfirmationButtons: some View {
        Button("删除", role: .destructive) {
            if let event {
                if let eventIdentifier = event.eventIdentifier {
                    Task {
                        await CalendarUtils.deleteEventById(eventIdentifier)
                    }
                }

                vm.deleteEvent(event)

                dismiss()
            }
        }
        Button("取消", role: .cancel) { }
    }

    // MARK: Sheet Content

    // MARK: Form Content

    private var formContent: some View {
        Group {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        TipView(changeIconTip, arrowEdge: .bottom)
                            .tipBackground(Color(.systemGray5))
                        iconView()
                        Spacer()
                    }

                    Spacer()
                }
            }
            .listRowBackground(Color(.clear))
            .listSectionSpacing(0)

            LabeledContent("标题") {
                TextField(text: $cb.title) {
                    Text("事件名称")
                }
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .submitLabel(.done)
                .listSectionSpacing(0)
            }

            ColorSectionView(colorHex: $cb.colorHex)

            TagSectionView(cb: cb)

            AllDaySectionView(cb: cb)

            RepeatSectionView(cb: cb)

            NotificationSectionView(cb: cb)
                .onChange(of: cb.firstNotification) { oldValue, newValue in
                    if newValue == .none && oldValue != .none && cb.secondNotification != .none {
                        cb.firstNotification = cb.secondNotification
                        cb.secondNotification = .none
                    }
                }

            deleteSection
        }
    }

    private var deleteSection: some View {
        return Button(role: .destructive, action: {
            showDeleteConfirm = true
        }, label: {
            Text("删除")
        }).disabled(event == nil)
            .tint(Color(.systemRed))
    }
}
