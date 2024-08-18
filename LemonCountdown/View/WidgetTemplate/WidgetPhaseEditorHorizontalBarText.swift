//
//  TextAndButtonView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/10.
//

import LemonUtils
import SwiftMovable
import SwiftUI

struct WidgetPhaseEditorHorizontalBarText: View {
    @Binding var selected: MovableObject?
    @Binding var text: String
    @Binding var textAction: TextAction

//    @Binding private var showInputText = false

    var addTextItemCallback: (String) -> Void = { _ in }

    var disable: Bool {
        if let textItem = selected as? TextItem {
            return !textItem.editable
        }
        return true
    }

    var body: some View {
        HStack {
//            TextField("输入文本", text: Binding<String>(
//                get: {
//                    if let textItem = selected as? TextItem {
//                        return textItem.text
//                    }
//                    return text
//                },
//                set: { newText in
//                    if let textItem = selected as? TextItem {
//                        textItem.text = newText
//
//                    } else {
//                        text = newText
//                    }
//                }
//            ))
//            .textFieldStyle(.roundedBorder).padding(.leading)
//            .submitLabel(.done)

            Spacer()
            Button(action: {
//                showInputText = true
            }, label: {
                Text("Add Text")
            }).buttonStyle(BorderedButtonStyle())

//            Button(textAction.rawValue) {
//                if textAction == .add {
//                    addTextItemCallback(text)
//                }
//
//            }.padding()
        }
//        .background(Color.gray.opacity(0.2))
//        .opacity(disable ? 0 : 1)
    }
}

struct CloseButton: UIViewRepresentable {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .close)

        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)

        button.addTarget(context.coordinator, action: #selector(Coordinator.perform), for: .primaryActionTriggered)
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        context.coordinator.action = action
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    class Coordinator {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc func perform() {
            action()
        }
    }
}
