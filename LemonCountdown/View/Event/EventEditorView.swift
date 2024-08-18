//
//  AddEventView.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import EventKit
import HorizontalPicker
import LemonCountdownModel
import LemonUtils
import Shift
import SwiftData
import SwiftUI
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
    @State private var initialized = false

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

                .onAppear {
                    if !initialized {
                        initEvent()
                        initialized = true
                    }
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

let weekDays: [(LocalizedStringKey, UInt8)] = [
    ("星期一", 1),
    ("星期二", 2),
    ("星期三", 4),
    ("星期四", 8),
    ("星期五", 16),
    ("星期六", 32),
    ("星期日", 64)
]

struct TagSectionView: View {
    @Bindable var cb: EventBuilder

    @Environment(ViewModel.self) private var vm

    @Query(sort: \Tag.sortValue) private var tags: [Tag] = []

    var body: some View {
        Section {
            Picker(selection: $cb.tag) {
                Text("无").tag(nil as Tag?)
                Divider()
                ForEach(tags) { tag in
                    Text(tag.title).tag(tag as Tag?)
                }
            } label: {
                Text("标签")
            }

            NavigationLink {
                TagManagementView()
            } label: {
                Text("标签管理")
            }
        }
    }
}

struct AllDaySectionView: View {
    @Bindable var cb: EventBuilder

    var body: some View {
        Section {
            Toggle("全天", isOn: Binding(get: {
                cb.isAllDayEvent
            }, set: { newValue in
                cb.isAllDayEvent = newValue
                cb.firstNotification = .none
                cb.secondNotification = .none

                if newValue {
                    cb.adjustDate()
                }
            }))

            DatePicker("目标日期", selection: $cb.startDate, displayedComponents: [.date])
                .onChange(of: cb.startDate) { _, newValue in
                    let endDateComponents = Calendar.current.dateComponents([.hour, .minute], from: cb.endDate)
                    cb.endDate = Calendar.current.date(bySettingHour: endDateComponents.hour!, minute: endDateComponents.minute!, second: 0, of: newValue)!
                }

            if !cb.isAllDayEvent {
                DatePicker("开始时间", selection: $cb.startDate, displayedComponents: [.hourAndMinute])
                DatePicker("结束时间", selection: $cb.endDate, displayedComponents: [.hourAndMinute])
            }
        }
    }
}

struct RepeatSectionView: View {
    @Bindable var cb: EventBuilder

    var body: some View {
        Section {
            Toggle("重复", isOn: $cb.isRepeatEnabled)
            if cb.isRepeatEnabled {
                NavigationLink {
                    RepeatPickerView(recurrenceType: $cb.recurrenceType, repeatPeriod: $cb.repeatPeriod, repeatInterval: $cb.repeatInterval, customWeek: $cb.repeatCustomWeekly)
                } label: {
                    Text(repeatText(recurrenceType: cb.recurrenceType, repeatPeriod: cb.repeatPeriod, repeatInterval: cb.repeatInterval))
                }

                if cb.recurrenceType == .customWeekly {
                    Text(repeatTextCustomWeekly(repeatCustomWeekly: cb.repeatCustomWeekly))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Toggle("结束重复", isOn: $cb.hasRepeatEndDate)
                if cb.hasRepeatEndDate {
                    DatePicker("结束日期", selection: Binding(get: {
                        cb.repeatEndDate ?? .now
                    }, set: { value in
                        cb.repeatEndDate = value
                    }), in: max(cb.startDate, cb.endDate)..., displayedComponents: .date)
                }
            }
        }
    }
}
