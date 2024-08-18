//
//  RepeatPicker.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/1.
//

import LemonDateUtils
import LemonUtils
import SwiftUI

struct ReminderPickerView: View {
    @Environment(\.dismiss) private var dismiss

    private let data: [[String]] = [
        Array(1 ..< 24).map {
            "\($0)"
        },
        RepeatPeriod.allCases.map {
            $0.text
        }
    ]

    @Binding private var selections: [Int]

    init(selections: Binding<[Int]>) {
        _selections = selections
    }

    var body: some View {
        VStack(alignment: .center) {
            MultiComponentPickerView(data: data, selections: $selections)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderPickerView(selections: .constant([1, 1]))
    }
}
