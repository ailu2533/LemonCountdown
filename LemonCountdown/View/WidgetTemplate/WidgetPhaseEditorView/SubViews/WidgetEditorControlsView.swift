//
//  WidgetEditorControlsView.swift
//  LemonCountdown
//
//  Created by Lu Ai on 2024/8/19.
//

import HorizontalPicker
import LemonCountdownModel
import PagerTabStripView
import SwiftMovable
import SwiftUI



struct WidgetEditorControlsView: View {
    @Bindable var phase: WidgetPhase
    @Bindable var vm: WidgetPhaseEditorViewModel
    let height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ControlPanel(selectedControl: $vm.selectedControl, selectedSticker: $vm.selectedSticker, showInputText: $vm.showInputText, selectedBackgroundKind: $vm.selectedBackgroundKind)
                .contentMargins(.horizontal, 12)
                .frame(maxHeight: 30)
                .padding(.vertical, 10)

            PagerTabStripView(swipeGestureEnabled: .constant(false), selection: $vm.selectedControl) {
                ForEach(Control.allCases, id: \.self) { control in
                    control.view(vm: vm, phase: phase)
                        .pagerTabItem(tag: control) {
                            TabItemView(title: control.text)
                        }
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
    }
}
