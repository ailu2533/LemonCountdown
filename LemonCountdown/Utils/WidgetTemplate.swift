//
//  WidgetTemplate.swift
//  LemonEvent
//
//  Created by ailu on 2024/5/6.
//

import Foundation

@Observable
class WidgetTemplate: Codable {
    var widgetTempletModel: WidgetTemplateModel?

    var phases: [WidgetPhase] = []

    enum CodingKeys: String, CodingKey {
        case phases
    }

    init(phases: [WidgetPhase] = []) {
        self.phases = phases
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phases = try container.decode([WidgetPhase].self, forKey: .phases)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(phases, forKey: .phases)
    }
}

extension WidgetTemplate: Hashable {
    static func == (lhs: WidgetTemplate, rhs: WidgetTemplate) -> Bool {
        return lhs.phases == rhs.phases
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(phases)
        if let widgetTempletModel {
            hasher.combine(widgetTempletModel.size)
        }
    }
}
