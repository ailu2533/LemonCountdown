//
//  ViewModel+TagModel.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/7.
//

import LemonCountdownModel
import SwiftData
import SwiftUI

extension ViewModel {
//    var allTags: [Tag] {
//        _ = tagVersion
//        return fetchAllTags()
//    }

    // 获取所有Tag, 根据 sortValue 排序
    func fetchAllTags() -> [Tag] {
        // 打印 debug 日志
        Logging.shared.info("fetchAllTags")

        let descriptor = FetchDescriptor<Tag>(sortBy: [SortDescriptor<Tag>(\.sortValue)])

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            Logging.shared.error("Failed to fetch tags: \(error.localizedDescription)")
        }
        return []
    }

    // 修改标签 sortValue
    func updateTags(titles: [String]) {
        // 创建一个从标题到索引的映射
        let titleToIndexMap = Dictionary(uniqueKeysWithValues: titles.enumerated().map { ($1, $0) })

        // 获取所有标签
        let allTags = fetchAllTags()

        // 更新标签的排序值
        allTags.forEach { tag in
            if let newIndex = titleToIndexMap[tag.title] {
                if tag.sortValue != newIndex {
                    tag.sortValue = newIndex
                }
            } else {
//                print("Warning: No index found for tag title '\(tag.title)'.")
                Logging.shared.error("Warning: No index found for tag title '\(tag.title)'.")
            }
        }

        // 增加版本号以追踪更改
        tagVersion += 1
    }

    // 删除标签
    func deleteTag(dels: [String]) {
        let tags = fetchAllTags()
        tags.forEach {
            if dels.contains($0.title) {
                modelContext.delete($0)
            }
        }
        tagVersion += 1
    }

    // 新增标签
    func addTag(title: String, sortValue: Int) -> Bool {
        let tag = Tag(title: title, sortValue: sortValue)
        modelContext.insert(tag)
        tagVersion += 1
        return true
    }
}
