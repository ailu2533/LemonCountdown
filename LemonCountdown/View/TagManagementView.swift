//
//  TagManagementView.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/3.
//

import SwiftData
import SwiftUI

struct TagManagementView: View {
    @Environment(ViewModel.self) private var vm
    @Environment(\.dismiss) private var dismiss
    @State private var inputTagTitle = ""
    @State private var tagTitles: [String] = []
    @State private var showToast = false

    func getSelectedTag() -> String? {
        return UserDefaults.standard.string(forKey: "selectedTag")
    }

    init() {
        Logging.shared.debug("TagManagementView init")
    }

    fileprivate func addTag() {
        if inputTagTitle.isEmpty {
            showToast = true
            return
        }
        if !tagTitles.contains(inputTagTitle) {
            tagTitles.append(inputTagTitle)
            if vm.addTag(title: inputTagTitle, sortValue: tagTitles.count) {
                inputTagTitle = ""
            }
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("标签名称", text: $inputTagTitle)
                    .submitLabel(.done)
                    .onSubmit {
                        guard !inputTagTitle.isEmpty else { return }
                        addTag()
                    }
                Button(action: {
                    addTag()
                }, label: {
                    Text("添加标签")
                })
            }

            Section {
                List {
                    ForEach(tagTitles, id: \.self) {
                        Text($0)
                    }
                    .onMove(perform: { indices, newOffset in
                        tagTitles.move(fromOffsets: indices, toOffset: newOffset)
                        vm.updateTags(titles: tagTitles)
                    })
                    .onDelete { indices in
                        let dels = indices.map {
                            tagTitles[$0]
                        }
                        tagTitles.remove(atOffsets: indices)

                        vm.deleteTag(dels: dels)

                        dels.forEach {
                            if $0 == getSelectedTag() {
                                UserDefaults.standard.set(nil, forKey: "selectedTag")
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text("全部标签")
                    Spacer()
                    EditButton()
                }
            }
        }
        .onAppear(perform: {
            tagTitles = vm.fetchAllTags().map(\.title)
        })
    }
}
